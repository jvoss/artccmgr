class CreateCronoJobs < ActiveRecord::Migration[5.1]
  def self.up
    create_table :crono_jobs, id: :uuid do |t|
      t.string    :job_id, null: false
      t.text      :log, limit: 1073741823 # LONGTEXT for MySQL
      t.datetime  :last_performed_at
      t.boolean   :healthy
      t.timestamps null: false
    end
    add_index :crono_jobs, [:job_id], unique: true
  end

  def self.down
    drop_table :crono_jobs
  end
end