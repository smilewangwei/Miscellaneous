# _*_ coding:utf-8 _*_
import os


dir='./text'
path='./text/text.txt'
if not os.path.exists(dir):
    os.makedirs(dir)
if not os.path.exists(path):
    with open(path,'wb') as target:
        target.close()