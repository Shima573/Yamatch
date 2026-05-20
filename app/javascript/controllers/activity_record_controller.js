import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="activity-record"
export default class extends Controller {
  static targets = [
    "submitButton",
    "climbedAt",
    "mountain",
    "title",
    "images",
    "newPreview",
    "existingPreview",
    "imageError",
    "removeImage",
    "deletePhotoIds"
  ]
  connect() {
    this.selectedFiles = []
    this.checkForm()
    // 生成したURLを追跡するための配列（掃除用）
    this.previewUrls = []
    this.photoIds = []
    // 削除予約リスト
    this.deletedPhotoIds = []
    // DOM（HTML）に埋め込まれた初期データを読む
    this.existingCount = Number(this.element.dataset.existingCount)
  }

  // 入力チェック
  checkForm() {
    if (
      this.climbedAtTarget.value &&
      this.mountainTarget.value &&
      this.titleTarget.value
    ) {
      this.submitButtonTarget.disabled = false
    } else {
      this.submitButtonTarget.disabled = true
    }
  }

  // 画像選択時
  previewImages() {
    const newFiles = Array.from(this.imagesTarget.files)

    // エラーメッセージの削除
    this.imageErrorTarget.textContent = "";

    // 1. 現在の枚数 + 新しく選んだ枚数が3枚を超える場合はエラー
    if (this.totalImages() + newFiles.length > 3 ) {
      this.imageErrorTarget.textContent = "画像は3枚までです"
      // inputの中身を現在の配列(selectedFiles)の状態に戻す
      this.syncInput()
      return
    }

    // 2. サイズチェック（例：5MB制限）
    const oversized = newFiles.some(file => file.size > 5 * 1024 * 1024)
    if (oversized) {
      this.imageErrorTarget.textContent = "5MBを超える画像が含まれています"
      this.syncInput()
      return
    }

    // 配列を上書きせず、既存の配列に結合する
    this.selectedFiles = [...this.selectedFiles, ...newFiles]

    this.syncInput()
    this.renderPreview()
  }

  // JSの配列と inputタグの files を同期させる
  syncInput() {
    const dataTransfer = new DataTransfer()
    this.selectedFiles.forEach(file => dataTransfer.items.add(file))
    this.imagesTarget.files = dataTransfer.files
  }

  // プレビュー表示
  renderPreview() {
    // 既存のURLを一度すべて解放してリセット
    this.clearPreviewUrls()

    this.newPreviewTarget.innerHTML = ""

    this.selectedFiles.forEach((file, index) => {
      const imageUrl = URL.createObjectURL(file)
      this.previewUrls.push(imageUrl) // URL追跡用

      const previewHtml = `
      <div class="relative border border-primary-300/20 rounded-xl justify-self-start p-2">
        <img src="${imageUrl}" class="w-32 h-32 object-cover rounded ">

        <button type="button"
        class="absolute -top-1 -right-2 bg-primary-90 text-primary-10 rounded-full w-6 h-6 cursor-pointer"
        data-action="click->activity-record#removeImage"
        data-index="${index}">
        ✕
        </button>
      </div>`

      this.newPreviewTarget.insertAdjacentHTML('beforeend', previewHtml)
    })
  }

  totalImages() {
    const remainingExisting = this.existingCount - this.deletedPhotoIds.length
    const total = remainingExisting + this.selectedFiles.length

    return total
  }

  // 生成されたオブジェクトURLをすべて無効化する
  clearPreviewUrls() {
    this.previewUrls.forEach(url => URL.revokeObjectURL(url))
    this.previewUrls = []
  }

  // 削除処理
  removeImage(event) {
    const index = Number(event.currentTarget.dataset.index)
    const photoId = event.currentTarget.dataset.photoId

    if (photoId) {
      // DB画像
      this.deletedPhotoIds.push(photoId)
      // 値を詰め込むイメージ（removeImage関数の中）
      this.deletePhotoIdsTarget.value = this.deletedPhotoIds.join(",")
      // 画面から削除
      event.currentTarget.parentElement.remove()
    } else {
      // 新規画像, 配列から削除
      this.selectedFiles.splice(index, 1)

      // 同期と再描画
      this.syncInput()
      this.renderPreview()
    }
  }

  disconnect() {
    this.clearPreviewUrls()
  }
}
