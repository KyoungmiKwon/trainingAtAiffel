# %%
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.neighbors import KNeighborsClassifier
from sklearn.neighbors import KNeighborsRegressor
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
# %%
# 도미데이터
bream_length = [25.4, 26.3, 26.5, 29.0, 29.0, 29.7, 29.7, 30.0, 30.0, 30.7, 31.0, 31.0, 31.5, 32.0, 32.0, 32.0, 33.0, 33.0, 33.5, 33.5, 34.0, 34.0, 34.5, 35.0, 35.0, 35.0, 35.0, 36.0, 36.0, 37.0, 38.5, 38.5, 39.5, 41.0, 41.0]
bream_weight = [242.0, 290.0, 340.0, 363.0, 430.0, 450.0, 500.0, 390.0, 450.0, 500.0, 475.0, 500.0, 500.0, 340.0, 600.0, 600.0, 700.0, 700.0, 610.0, 650.0, 575.0, 685.0, 620.0, 680.0, 700.0, 725.0, 720.0, 714.0, 850.0, 1000.0, 920.0, 955.0, 925.0, 975.0, 950.0]

# 방어데이터 준비
smelt_length = [9.8, 10.5, 10.6, 11.0, 11.2, 11.3, 11.8, 11.8, 12.0, 12.2, 12.4, 13.0, 14.3, 15.0]
smelt_weight = [6.7, 7.5, 7.0, 9.7, 9.8, 8.7, 10.0, 9.9, 9.8, 12.2, 13.4, 12.2, 19.7, 19.9]

# 도미와 방어 데이터 결합
length = bream_length + smelt_length
weight = bream_weight + smelt_weight

# fish_dt = [[l, w] for l, w in zip(length, weight)]
fish_dt = np.column_stack((length, weight))

# fish_tg = [1] * len(bream_length) + [0] * len(smelt_length)
fish_tg = np.concatenate((np.ones(len(bream_length)), np.zeros(len(smelt_length))))

# %%
""" 훈련 데이터와 테스트 데이터 분할 1"""

inp_dt = np.array(fish_dt)
tgt_dt = np.array(fish_tg)

# 데이터 섞기 for preventing sampling bias (샘플편향 방지)
# np.random.seed(42) # 랜덤 시드 고정
np.random.seed(42)
idx = np.arange(len(inp_dt))
np.random.shuffle(idx)

idx
# %%
# 데이터 분할
# 80% 훈련 데이터, 20% 테스트 데이터
train_size = int(len(inp_dt) * 0.8) # 훈련 데이터 개수
train_idx = idx[:train_size] # 훈련 데이터 인덱스
test_idx = idx[train_size:] # 테스트 데이터 인덱스
train_idx, test_idx

# %%
""" 훈련 데이터와 테스트 데이터 분할 2 """
# train_test_split()는 데이터를 랜덤하게 섞어서 분할
# stratify : 비율을 유지하면서 분할
tr_inp, ts_inp, tr_tgt, ts_tgt = train_test_split(fish_dt, fish_tg, stratify = fish_tg, random_state=42)
# %%
"""Scaling 
=> 훈련, 테스트, 예측 데이터 모두 스케일링 필요 on 훈련 데이터 기준 주의!
중요한 점은 **훈련 데이터로 학습한 스케일링 기준(평균과 표준편차)**을 사용해야 함
새로운 데이터 자체로 스케일링 기준을 다시 학습하면 **데이터 누수(data leakage)**가 발생할 수 있음
즉, 훈련 데이터로 학습한 스케일링 기준을 사용하여 테스트 데이터와 예측 데이터도 변환해야 함
"""
sScaler = StandardScaler() # 표준화 객체 생성
sScaler.fit(tr_inp) # 훈련 데이터로 스케일링 기준 학습
tr_inp_sc = sScaler.transform(tr_inp) # 훈련 데이터 스케일링
# tr_inp_sc = sScaler.fit_transform(tr_inp) # 훈련 데이터 스케일링
# %%
len(tr_inp_sc), len(tr_tgt) # 훈련 데이터 개수 확인
# %%
# 모델훈련
kn = KNeighborsClassifier()
kn.fit(tr_inp_sc, tr_tgt) # 훈련 데이터로 모델 학습
kn.score(tr_inp_sc, tr_tgt) # 훈련 데이터로 모델 평가
# %%
# predition
new_dt = [[25, 150]] # 예측할 데이터
new_dt_sc = sScaler.transform(new_dt) # 스케일링 with 훈련 데이터 기준
kn.predict(new_dt_sc) # 예측
# %%
plt.scatter(tr_inp_sc[:, 0], tr_inp_sc[:, 1], c=tr_tgt, cmap='viridis', s=50)
plt.scatter(new_dt_sc[0, 0], new_dt_sc[0, 1], marker='^', c='red', s=100) # 예측값 1(도미)
plt.xlabel('length')
plt.ylabel('weight')
plt.title('KNN Classifier')
plt.show()  

# %%
dis, idx = kn.kneighbors(new_dt_sc) # 최근접 이웃
dis, idx
# %%
plt.scatter(tr_inp_sc[:, 0], tr_inp_sc[:, 1], c=tr_tgt, cmap='viridis', s=50)
plt.scatter(new_dt_sc[0, 0], new_dt_sc[0, 1], marker='^', c='red', s=100) # 예측값 1(도미)
plt.scatter(tr_inp_sc[idx, 0], tr_inp_sc[idx, 1], marker='o', c='blue', s=100) # 최근접 이웃
plt.xlabel('length')
plt.ylabel('weight')
plt.title('KNN Classifier')
plt.show()
# %%
# 모델 평가
tr_tgt_pred = kn.predict(tr_inp_sc) # 훈련 데이터 예측
tr_tgt_pred
# %%
accuracy_score(tr_tgt, tr_tgt_pred) # 훈련 데이터 정확도
# %%
