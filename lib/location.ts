  const prefectureLocations = {
  "北海道": { lat: 43.0642, lng: 141.3468 },
  "青森": { lat: 40.8243, lng: 140.7400 },
  "岩手": { lat: 39.7036, lng: 141.1525 },
  "宮城": { lat: 38.2682, lng: 140.8694 },
  "秋田": { lat: 39.7186, lng: 140.1024 },
  "山形": { lat: 38.2554, lng: 140.3396 },
  "福島": { lat: 37.7503, lng: 140.4675 },
  "茨城": { lat: 36.3418, lng: 140.4468 },
  "栃木": { lat: 36.5657, lng: 139.8836 },
  "群馬": { lat: 36.3895, lng: 139.0634 },
  "埼玉": { lat: 35.8569, lng: 139.6489 },
  "千葉": { lat: 35.6046, lng: 140.1233 },
  "東京": { lat: 35.6895, lng: 139.6917 },
  "神奈川": { lat: 35.4475, lng: 139.6423 },
  "新潟": { lat: 37.9022, lng: 139.0236 },
  "富山": { lat: 36.6953, lng: 137.2113 },
  "石川": { lat: 36.5947, lng: 136.6256 },
  "福井": { lat: 36.0652, lng: 136.2216 },
  "山梨": { lat: 35.6639, lng: 138.5683 },
  "長野": { lat: 36.6513, lng: 138.1810 },
  "岐阜": { lat: 35.3912, lng: 136.7223 },
  "静岡": { lat: 34.9756, lng: 138.3831 },
  "愛知": { lat: 35.1802, lng: 136.9066 },
  "三重": { lat: 34.7303, lng: 136.5086 },
  "滋賀": { lat: 35.0045, lng: 135.8686 },
  "京都": { lat: 35.0212, lng: 135.7556 },
  "大阪": { lat: 34.6864, lng: 135.5199 },
  "兵庫": { lat: 34.6913, lng: 135.1830 },
  "奈良": { lat: 34.6853, lng: 135.8327 },
  "和歌山": { lat: 34.2260, lng: 135.1675 },
  "鳥取": { lat: 35.5039, lng: 134.2377 },
  "島根": { lat: 35.4722, lng: 133.0505 },
  "岡山": { lat: 34.6618, lng: 133.9344 },
  "広島": { lat: 34.3852, lng: 132.4553 },
  "山口": { lat: 34.1785, lng: 131.4737 },
  "徳島": { lat: 34.0657, lng: 134.5593 },
  "香川": { lat: 34.3428, lng: 134.0466 },
  "愛媛": { lat: 33.8416, lng: 132.7657 },
  "高知": { lat: 33.5597, lng: 133.5311 },
  "福岡": { lat: 33.6064, lng: 130.4182 },
  "佐賀": { lat: 33.2635, lng: 130.3009 },
  "長崎": { lat: 32.7503, lng: 129.8777 },
  "熊本": { lat: 32.7898, lng: 130.7417 },
  "大分": { lat: 33.2382, lng: 131.6126 },
  "宮崎": { lat: 31.9077, lng: 131.4202 },
  "鹿児島": { lat: 31.5601, lng: 130.5579 },
  "沖縄": { lat: 26.2124, lng: 127.6809 }
  }


  function isSamePrefecture(userPrefecture, mountainPrefecture) {
  return userPrefecture === mountainPrefecture
  }

  function getPrefectureLocation(prefName){
  // ここに処理を書く
  return prefectureLocations[prefName]
  }

  function getDistance(pointA, pointB) {
  const R = 6371; // 地球の半径 (km)

  // ここに距離計算
  const lat1 = pointA.lat
  const lng1 = pointA.lng
  const lat2 = pointB.lat
  const lng2 = pointB.lng

  // 緯度をラジアンへ変換
  const radLat1 = lat1 * (Math.PI / 180)
  const radLat2 = lat2 * (Math.PI / 180)

  // 経度をラジアンへ変換
  const radLng1 = lng1 * (Math.PI / 180)
  const radLng2 = lng2 * (Math.PI / 180)

  // 2点の「差」を出す
  const dLat = radLat2 - radLat1
  const dLng = radLng2 - radLng1

  // 「2点がどれくらい離れてるかの割合（中間値）」
  const a =
  Math.sin(dLat / 2) * Math.sin(dLat / 2) +
  Math.cos(radLat1) * Math.cos(radLat2) *
  Math.sin(dLng / 2) * Math.sin(dLng / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  const distance = R * c;
  return distance
  }

  function isNearby(userPrefecture, mountain) {
  // ① 同じ都道府県なら true
  if (isSamePrefecture(userPrefecture, mountain.prefecture)) {
  return true
  }
  const userLocation = getPrefectureLocation(userPrefecture)
  // userLocationがなければreturn false
  if (!userLocation) {
  return false
  }

  const mountainLocation = {
  lat: mountain.lat,
  lng: mountain.lng
  }

  const distance = getDistance(userLocation, mountainLocation)

  // 距離が50以内なら true
  return distance < 50
  }
