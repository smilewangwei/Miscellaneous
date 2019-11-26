# _*_ coding:utf-8 _*_
import requests
from bs4 import BeautifulSoup
from fake_useragent import UserAgent
from lxml import etree



def main():
    # url='https://blog.csdn.net/fashion2014/article/details/78826299#commentBox'
    headers={
    'User-Agent':UserAgent().random
    }
    url='https://www.pearvideo.com/category_59'
    response=requests.get(url,headers=headers,timeout=10)
    res_xpath=etree.HTML(response.text) #第一步给内容转为xpath结构
    # title1=res_xpath.xpath('/html/head/title/text()')
    title2=res_xpath.xpath('//title/text()')  #找到title输出文本
    print(title2)
if __name__ == "__main__":
    main()