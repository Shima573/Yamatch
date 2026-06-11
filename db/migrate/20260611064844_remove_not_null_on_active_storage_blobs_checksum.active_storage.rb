# db/migrate/20260611064844_remove_not_null_on_active_storage_blobs_checksum.active_storage.rb

class RemoveNotNullOnActiveStorageBlobsChecksum < ActiveRecord::Migration[8.0]
  def change
    # データベース側はすでに最新（NULL許容）のため、
    # Rails 8の自動補完によるSQLエラーを避けるために中身を空にします。
  end
end
