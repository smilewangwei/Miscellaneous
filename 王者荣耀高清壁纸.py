# coding=utf-8
import requests
import os #操作文件夹

url='http://pvp.qq.com/web201605/wallpaper.shtml'
hero_url = 'https://pvp.qq.com/web201605/js/herolist.json'
headers={'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36'}


# 获取英雄列表
def get_hero():
    request=requests.get(hero_url) #请求官方json
    hero_list=request.json()
    return hero_list #返回获获取到的json

# 接受英雄参数，皮肤个数
def gtimg():  
    if not os.path.exists('./hero'): #判断文件夹是否存在
        os.mkdir('./hero')
    else:
        for hero_list in get_hero():
            page=  hero_list.get('skin_name','none').split('|'),#直接使用[]取值会异常 keyerror
            if page[0][0]!='none': #筛选掉官方未提供的插画
                for skin_list in range(1,len(page[0])+1): #获取单个英雄的皮肤
                    # print(hero_list.get('cname'),skin_list,page[0][skin_list-1])
                    url='http://game.gtimg.cn/images/yxzj/img201606/skin/hero-info/%s/%s-bigskin-%s.jpg' % (hero_list.get('ename'),hero_list.get('ename'),skin_list) #传递获取到的参数
                    request=requests.get(url) #带入参数请求图片
                    with open('./hero/'+hero_list.get('cname')+'-'+page[0][skin_list-1]+'.jpg','wb') as img: #存取图片文件（命名）
                        print('正在下载%s%s' %(hero_list.get('cname'),page[0][skin_list-1])) #下载提示信息
                        img.write(request.content)
                        img.close()

# 程序入口
def main():
    gtimg()
    

if __name__ == "__main__":
    main()






