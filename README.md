### 2019 스마트서울 모바일 앱 공모전



> 공모전명: 2019년 스마트서울 모바일 앱 공모전
>
> 공모과제: 서울시와 관련된 공익성을 담은 작품
>
> 공모기간: 2019. 8.1.(목) ~ 2019. 9. 30.(월)



##### 기획배경
등산을 조금 더 재밌게 하면서 정확한 기록을 측정 할 순 없을까? 하는 고민에서 시작되었습니다.



##### 기존 출시된 앱과의 차별성

사진만 찍으면 사진에 담긴 정보를 가져와 위치와 고도를 측정하여 등산기록을 간편하게 남길 수 있게 만들었습니다.



##### 서비스내용

#####



<img src="https://user-images.githubusercontent.com/47776915/66712294-911e2680-edd5-11e9-89a7-dacd74b6fa51.PNG" alt="IMG_3289" style="zoom:25%;" /><img src="https://user-images.githubusercontent.com/47776915/66712306-b01cb880-edd5-11e9-8fef-812ee370ca96.PNG" alt="IMG_3288" style="zoom:25%;" />  <img src="https://user-images.githubusercontent.com/47776915/66712295-97ac9e00-edd5-11e9-9ffa-7226390ab107.PNG" alt="IMG_3286" style="zoom:25%;" /> <img src="https://user-images.githubusercontent.com/47776915/66712300-a004d900-edd5-11e9-8c4a-baa7f4982f7d.PNG" alt="IMG_3284" style="zoom:25%;" /> <img src="https://user-images.githubusercontent.com/47776915/66712302-a4c98d00-edd5-11e9-8225-4acc5bd3901f.PNG" alt="IMG_3285" style="zoom:25%;" /> <img src="https://user-images.githubusercontent.com/47776915/66712303-a6935080-edd5-11e9-891a-b9b3482988b9.PNG" alt="IMG_3287" style="zoom:25%;" />





#### MVP

* ##### 유저가 촬영한 사진 정보로 부터 위경도, 고도, 시간을 기준으로 `출발-도착` 정보를 얻어 각 산에 대한 랭킹 순위 결정

* ##### launch screen과 main view를 animation을 자연스럽게 연결하고  Main view에서 서울시의 산이 돋보이는 animation 구현

* ##### 랭킹 중 1...3 위의 기록을 Firebase db에 등록 산 클릭시 정보를 표기, 1위는 등산 인증 이미지를 저장하여 클릭시 이미지 표시 되도록 구현

* ##### 유저의 등산 리스트를 개인기기의 DB에 등록 or firebase DB에 저장하여 개인 등반 히스토리를 확인 할수 있도록 한다.
