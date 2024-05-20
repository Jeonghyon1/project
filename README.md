# Experiment of Logic Circuit Design
# Group 8


### 각자 날짜, 코드 이름, 추가 혹은 수정 내용 적기
#### ex) 2024.05.18 not_gate.v: NOT GATE 추가


---

### 김민주




---

### 김정현




---

### 박상혁




---

### 신태하
5/18 added `rtc.v`: 클럭을 세어서 시간으로 변환해줌. 누적시간과 현재 ms를 출력함.  
`seconds.v`, `minutes.v`, `hours.v`: ms 단위의 누적시간을 받아서 각 시간단위로 변환하고 overflow 시 0으로 돌아감. 현재시각이나 타이머 시간을 입력하려면 여기에 preset을 넣으면 됨.

5/20 `rtc.v`, `seconds.v`, `minutes.v`, `hours.v`: 각 모듈별 docstring 추가.  
5/20 `seconds.v` 등을 `time_transform.v`로 통합: 기존 자리올림 제대로 안되던 문제 해결+연월일 추가.  
added `bin2dec.v`, `dec2bin.v`: 이진수 표기와 10의 자리 1의 자리 나눠진 2진수 표기 간 전환.  
예시 _27_ bin2dec(011011)={0010, 0111} _15_ dec2bin({0001, 0101})=001111