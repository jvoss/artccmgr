# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feedback, type: :model do
  it 'has a valid factory' do
    expect(build(:feedback)).to be_valid
  end

  let(:feedback) { build(:feedback) }

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(feedback).to validate_presence_of(:cid) }
    it { expect(feedback).to validate_presence_of(:name) }
    it { expect(feedback).to validate_presence_of(:email) }
    it { expect(feedback).to validate_presence_of(:callsign) }
    it { expect(feedback).to validate_presence_of(:controller) }
    it { expect(feedback).to validate_presence_of(:position) }
    it { expect(feedback).to validate_presence_of(:service_level) }
    it { expect(feedback).to validate_presence_of(:comments) }

    # Format validations
    it {
      expect(feedback).to(
        validate_numericality_of(:service_level)
        .is_greater_than(0)
        .is_less_than_or_equal_to(5)
      )
    }

    # Inclusion/acceptance of values
    it { expect(feedback).to allow_value('Unknown').for(:controller) }
    it { expect(feedback).to allow_value('Unknown').for(:position) }

    it { expect(feedback).to_not allow_value('').for(:cid) }
    it { expect(feedback).to_not allow_value('').for(:name) }
    it { expect(feedback).to_not allow_value('').for(:email) }
    it { expect(feedback).to_not allow_value('').for(:callsign) }
    it { expect(feedback).to_not allow_value('').for(:controller) }
    it { expect(feedback).to_not allow_value('').for(:position) }
    it { expect(feedback).to_not allow_value('').for(:service_level) }
    it { expect(feedback).to_not allow_value('').for(:comments) }

    # Anonymous Mode
    it {
      expect(build(:feedback, anonymous: true)).to allow_value('').for(:cid)
    }

    it {
      expect(build(:feedback, anonymous: true)).to allow_value('').for(:name)
    }

    it {
      expect(build(:feedback, anonymous: true)).to allow_value('').for(:email)
    }

    it {
      expect(build(:feedback, anonymous: true)).to(
        allow_value('').for(:callsign)
      )
    }
  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do
  end # describe 'ActiveRecord associations'

  describe 'callsign should be forced upper case' do
    it { expect(build(:feedback, callsign: 'test').callsign).to eq 'TEST' }
  end
end
