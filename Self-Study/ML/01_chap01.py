# %%
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.neighbors import KNeighborsClassifier
# %%
# 도미데이터 준비
bream_length = [25.4, 26.3, 26.5, 29.0, 29.0, 29.7, 29.7, 30.0, 30.0, 30.7, 31.0, 31.0, 31.5, 32.0, 32.0, 32.0, 33.0, 33.0, 33.5, 33.5, 34.0, 34.0, 34.5, 35.0, 35.0, 35.0, 35.0, 36.0, 36.0, 37.0, 38.5, 38.5, 39.5, 41.0, 41.0]
bream_weight = [242.0, 290.0, 340.0, 363.0, 430.0, 450.0, 500.0, 390.0, 450.0, 500.0, 475.0, 500.0, 500.0, 340.0, 600.0, 600.0, 700.0, 700.0, 610.0, 650.0, 575.0, 685.0, 620.0, 680.0, 700.0, 725.0, 720.0, 714.0, 850.0, 1000.0, 920.0, 955.0, 925.0, 975.0, 950.0]

# %%
# 방어데이터 준비
smelt_length = [9.8, 10.5, 10.6, 11.0, 11.2, 11.3, 11.8, 11.8, 12.0, 12.2, 12.4, 13.0, 14.3, 15.0]
smelt_weight = [6.7, 7.5, 7.0, 9.7, 9.8, 8.7, 10.0, 9.9, 9.8, 12.2, 13.4, 12.2, 19.7, 19.9]

# %%
# 산점도 그리기
plt.scatter(bream_length, bream_weight)
plt.scatter(smelt_length, smelt_weight)
plt.xlabel('length')
plt.ylabel('weight')
plt.show()
# %%
# 도미와 방어 데이터 결합
length = bream_length + smelt_length
weight = bream_weight + smelt_weight

fish_dt = [[l, w] for l, w in zip(length, weight)]

fish_t = [1] * len(bream_length) + [0] * len(smelt_length)

fish_dt, fish_t
(fish_dt, fish_t)

# %%
# k-최근접 이웃 분류기

kn = KNeighborsClassifier() # 기본값 k=5
kn.fit(fish_dt, fish_t)
kn.score(fish_dt, fish_t)
# %%
# 새로운 데이터 예측하기
kn.predict([[30, 600]]) 
# %%
plt.scatter(bream_length, bream_weight)
plt.scatter(smelt_length, smelt_weight)
plt.scatter(30, 600, marker='^') # 예측값 1(도미)
plt.xlabel('length')
plt.ylabel('weight')
plt.show()
# %%
kn._fit_X # 훈련 데이터
# %%
kn._y # 훈련 데이터의 정답
# %%
kn_49 = KNeighborsClassifier(n_neighbors=49) #참고데이터를 49개로 한 모델
# 49개 중 도미가 35개 다수를 차지 하므로, 무조건 도미라고 예츨
kn_49.fit(fish_dt, fish_t)
kn_49.score(fish_dt, fish_t) # 전체 데이터 중 도미 비율과 동일 (0.71)
# %%
35/49 # 도미 비율
# %%
