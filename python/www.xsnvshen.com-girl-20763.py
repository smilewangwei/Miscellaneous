# _*_ coding:utf-8 _*_

import requests
from fake_useragent import UserAgent
import os
import urllib3
from lxml import etree
from bs4 import BeautifulSoup
import time
# 请求list
# 找子页面
# 提交请求
# 下载


headers={
    'User-Agent':UserAgent().random
}

def grir_list():
    # url='https://www.xsnvshen.com/album/31516'
    urllib3.disable_warnings()
    response=requests.get('https://www.xsnvshen.com/girl/20763',headers=headers,timeout=10,verify=False)
    stop=BeautifulSoup(response.text,'html.parser')
    for star_list in stop.select('.star-mod-bd ul li a'):
        print('https://www.xsnvshen.com/album/%s' % star_list.get('href').split('/')[2])
        grir_list_page('https://www.xsnvshen.com/album/%s' % star_list.get('href').split('/')[2])

        # grir_list_page(url)

# 获取当组的数量
def grir_list_page(url):
    # url='https://www.xsnvshen.com/album/31516'
    urllib3.disable_warnings()
    response=requests.get(url,headers=headers,verify=False)
    stup=BeautifulSoup(response.text,'html.parser')
    img=stup.select('.swl-item img')
    for target_list in img:
        grir_list_page_imgurl('https:%s'% target_list.get('data-original'))
        # print('https:%s'% target_list.get('data-original'))



# 下载图片
def grir_list_page_imgurl(url):
    if not os.path.exists('./%s'% url[31:].split('/')[0]):
        os.makedirs('./%s'% url[31:].split('/')[0])
    try:
        if os.path.exists('./%s'% url[31:].split('/')[0]+'/%s%s' %(url[31:].split('/')[1],url[31:].split('/')[2])):
            print('文件已存在%s%s' %(url[31:].split('/')[1],url[31:].split('/')[2]))
        else:
            print('正在下载%s'% url[31:].split('/')[0]+'/%s%s' %(url[31:].split('/')[1],url[31:].split('/')[2]))
            response=requests.get(url,headers=headers,timeout=10)
            if response.status_code==200:
                with open('./%s'% url[31:].split('/')[0]+'/%s%s' %(url[31:].split('/')[1],url[31:].split('/')[2]),'wb') as target:
                    target.write(response.content)
                    target.close()
            else:
                print('request error')
            
    except :
        print('Error')
 
    # imglist

def main():
    grir_list()
if __name__ == "__main__":
    main()
