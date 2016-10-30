# coding:utf-8
import sys
import pandas as pd
import numpy as np
from datetime import datetime
import csv
import random
import math

'''
第一引数：証券コード　第二引数：何日後か　第三引数：何通り導き出すか
python japan_stock.py 7203 365 1000
'''

base = 'http://info.finance.yahoo.co.jp/history/?code={0}.T&{1}&{2}&tm={3}&p={4}'
code = int(sys.argv[1])
endTime = datetime.now()
startTime = datetime(endTime.year - 1, endTime.month, endTime.day)
start = 'sy={0}&sm={1}&sd={2}'.format(startTime.year, startTime.month, startTime.day)
end = 'ey={0}&em={1}&ed={2}'.format(endTime.year, endTime.month, endTime.day)
interval = 'd'
p = 1
results = []

#過去一年間のデータ取得
while True:
    url = base.format(code, start, end, interval, p)
    tables = pd.read_html(url, header=0)
    if len(tables) < 2 or len(tables[1]) == 0:
        break
    results.append(tables[1])
    p += 1
result = pd.concat(results, ignore_index=True)

#以下解析
result.columns = ['Date', 'Open', 'High', 'Low', 'Close', 'Volume', 'Adj Close']
adj_close_rate = result['Adj Close'].pct_change()
rets = adj_close_rate.dropna()

def stock_montecarlo(startPrice, days, mu, sigma):
    price = np.zeros(days)
    price[0] = startPrice
    drift = mu/days
    for x in range(1,days):
        shock = random.uniform(-1,1) * sigma/math.sqrt(days)
        price[x] = price[x-1] + (price[x-1] * (drift + shock))
    return price

startPrice = result['Adj Close'].iloc[0]
days = int(sys.argv[2])
mu = rets.mean()
sigma = rets.std()
runs = int(sys.argv[3])
simulationSave = np.zeros([runs,days])

for run in range(1,runs):
    stack = stock_montecarlo(startPrice, days, mu, sigma)
    for day in range(1,days):
        simulationSave[run][day] = stack[day - 1]

result = np.zeros(days)
for day in range(1,days):
	for run in range(1,runs):
		result[day - 1] += simulationSave[run][day]
	result[day - 1] = result[day - 1]/runs


#結果出力 columns出力
#demo = pd.DataFrame(simulationSave)
#demo.to_csv('result.csv')

demo = pd.DataFrame(result)
demo.to_csv('result.csv')
