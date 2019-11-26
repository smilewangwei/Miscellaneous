# _*_ coding:utf-8 _*_
# m.keaitupian.com
import requests
from requests.exceptions import ReadTimeout
import os
from bs4 import BeautifulSoup
from fake_useragent import UserAgent
from lxml import etree

headers={
    'User-Agent': UserAgent().random
}

# 思路
# 获取人物ID方法类
# 获取最大分页数
# 获取实际图片信息（图片链接和人物标题）



    
# 传递前需去除空格
def down_img(url,title_page):
    # print(title_page.split()[0].replace('/',''),title_page.split()[1][3:-1])
    title=title_page.split()[0].replace('/','')
    page_list_size=[url[:-5]+'-%s%s'% (i,url[-5:]) for i in range(int(title_page.split()[1][3:-1]))]
    for img_list in page_list_size:
        response=requests.get(img_list,headers=headers,timeout=10)
        soup=BeautifulSoup(response.text,'html.parser')
        for img_src_list in soup.select('.bd a img'):
            try:
                if not os.path.exists('./keaitupian/'+title): #文件夹是否存在
                    os.makedirs('./keaitupian/'+title)
                print('正在下载：',img_src_list.get('src').split('/')[8])
                with open('./keaitupian/'+title+'/'+img_src_list.get('src').split('/')[8],'wb') as img:
                    img.write(requests.get(img_src_list.get('src'),headers=headers,timeout=10).content)
                    img.close()
            except ReadTimeout:
                print('read time out error')


def get_title_page(url):
    response=requests.get(url,headers=headers,timeout=10)
    try:
        if response.status_code==requests.codes['ok']:
            soup=BeautifulSoup(response.text,'html.parser')
            return str.strip(soup.h1.string).replace(' ','')
        else:
            print('request error')
    except ReadTimeout:
        print('read time out error')



def get_tag():
    for url_list in range(10):
        response=requests.get('https://m.keaitupian.com/tag-尤蜜荟/list-%s.html' % url_list,headers=headers,timeout=20)
        res_xpath=etree.HTML(response.text)
        return res_xpath.xpath('//div[@id="JwaterFall"]/ul/li/div[1]/a/@href')

def main():
    url_list='https://m.keaitupian.com/pic/6118.html'
    # for url_list in get_tag():
    #     get_title_page(url_list)
    #     down_img(url_list,get_title_page(url_list))
    down_img(url_list,get_title_page(url_list))
    

if __name__ == "__main__":
    main()