class CreatePullRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :pull_requests, id: :uuid do |t|
      t.string :number
      t.string :repository
      t.string :sha
      t.jsonb  :raw_payload

      t.timestamps
    end
  end
end
