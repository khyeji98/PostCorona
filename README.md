# PreventionOfCorona
포스트코로나 공모전 프로젝트

## 서버
### Firebase
- Auth
```Swift
// 이메일로 회원가입
Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
  if let error = error {
    print(error.localizedDescription)
  } else {
    // 회원가입과 동시에 로그인
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in //*아직 [weak self]는 왜 쓰는지 모르겠다. warning 뜸
      guard self != nil else { return }
      if let error = error {
        print(error.localizedDescription)
      }
      // navigationController rootView로 한번에 전환
      self?.navigationController?.popToRootViewController(animated: true)
    }
  }
}

//현재 로그인 중인 사용자 정보 불러오기
guard let userId = Auth.auth().currentUser?.uid else { return } // 사용자 uid 불러오기
guard let userEmail = Auth.auth().currenUser?.email else { return } // 사용자 email 불러오기
```
- Cloud Firestore
```Swift

```
- Storage

## 라이브러리
### XLPagerTapStrip

### FFPopup

### WebImage

## API
### 카카오맵(다음지도)
- 키워드로 주소 검색하기
