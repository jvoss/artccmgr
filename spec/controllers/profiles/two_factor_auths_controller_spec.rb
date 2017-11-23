# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profiles::TwoFactorAuthsController, type: :controller do
  before do
    sign_in(user)
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:pin) { 'pin-code' }

    def go
      post :create, params: { pin_code: pin }
    end

    context 'with a valid pin' do
      before do
        expect(user).to(
          receive(:validate_and_consume_otp!).with(pin).and_return(true)
        )
      end

      it 'enables 2fa for the user' do
        go
        user.reload
        expect(user).to be_two_factor_enabled
      end

      it 'presents plaintext codes for the user to save' do
        expect(user).to(
          receive(:generate_otp_backup_codes!).and_return(%w[a b c])
        )
        go
        expect(assigns[:codes]).to match_array %w[a b c]
      end

      it 'persists the generated codes' do
        go
        expect(user.otp_backup_codes).to_not be_empty
      end

      it 'renders create' do
        go
        expect(response).to render_template(:create)
      end
    end

    context 'with invalid pin' do
      before do
        expect(user).to(
          receive(:validate_and_consume_otp!).with(pin).and_return(false)
        )
      end

      it 'assigns error' do
        go
        expect(assigns[:error]).to eq 'Invalid pin code'
      end

      it 'assigns qr_code' do
        code = double('qr code')
        expect(subject).to receive(:build_qr_code).and_return(code)
        go
        expect(assigns[:qr_code]).to eq code
      end

      it 'renders show' do
        go
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user, :two_factor_via_otp, :two_factor_via_u2f) }

    it 'disables two factor' do
      expect(user).to receive(:disable_two_factor!)
      delete :destroy
    end

    it 'redirects to profile path' do
      delete :destroy
      expect(response).to redirect_to(profile_path)
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }

    it 'generates otp_secret for user' do
      expect(User).to(
        receive(:generate_otp_secret).with(32).and_return('secret').once
      )
      get :show
      get :show # second hit should not regenerate otp_secret
    end

    it 'assigns qr_code' do
      code = double('qr code')
      expect(subject).to receive(:build_qr_code).and_return(code)

      get :show
      expect(assigns[:qr_code]).to eq code
    end
  end
end