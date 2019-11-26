# _*_ coding:utf-8 _*_
# m.keaitupian.com
import requests
from requests.exceptions import ReadTimeout
import os
from bs4 import BeautifulSoup
from fake_useragent import UserAgent

headers={
    'User-Agent': UserAgent().random
}

# 思路
# 获取人物ID方法类
# 获取最大分页数
# 获取实际图片信息（图片链接和人物标题）



    
# 传递前需去除空格
def down_img(url,title_page):
    # url='https://m.keaitupian.com/pic/6405.html'
    title=title_page.split('/')[0][:-2].split('\t')[0]
    page_list_size=[url[:-5]+'-%s%s'% (i,url[-5:]) for i in range(int(title_page.split('/')[1][:-1]))]
    
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

def main():
    url='https://m.keaitupian.com/pic/6190.html'
    get_title_page(url)
    down_img(url,get_title_page(url))
    

if __name__ == "__main__":
    main()