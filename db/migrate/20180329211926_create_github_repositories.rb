class CreateGithubRepositories < ActiveRecord::Migration[5.1]
  def change
    create_table :github_repositories do |t|
      t.string :full_name
      t.string :url

      t.timestamps
    end
  end
end
