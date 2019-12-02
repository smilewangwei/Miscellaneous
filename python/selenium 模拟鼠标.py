# _*_ coding:utf-8 _*_

from selenium import webdriver #鼠标动作键
import time
from selenium.webdriver.common.action_chains import ActionChains #动作键
from selenium.webdriver.common.keys import Keys #键盘键
import random #随机数

# 初始化浏览器
driver=webdriver.Chrome()
driver.maximize_window()


# 鼠标左右键演示
def buttom():
    # 请求地址
    driver.get('http://sahitest.com/demo/clicks.htm')
    # 获取单击按钮的位置
    click_me=driver.find_element_by_xpath('/html/body/form/input[3]') #单击按钮ckeck me
    # 获取双击按钮的位置
    double_click_me=driver.find_element_by_xpath('/html/body/form/input[2]') #双击按钮
    # 获取右键按钮的位置
    right_click_me=driver.find_element_by_xpath('/html/body/form/input[4]') #鼠标右键

    # perform() ——执行链中的所有动作
    ActionChains(driver).click(click_me).double_click(double_click_me).context_click(right_click_me).perform()
    #attribute是HTML标签上的特性，它的值只能够是字符串。
    clicks=driver.find_element_by_name('t2').get_attribute('value')
    #property是DOM中的属性，是JavaScript里的对象；
    clicks2=driver.find_element_by_name('t2').get_property('value')

    print(clicks,clicks2)

    time.sleep(3)

    # 关闭浏览器
    driver.quit()


# 滑动演示
def mouseover():
    # 请求
    # driver.get('http://webcache.googleusercontent.com/search?q=cache:http://sahitest.com/demo/mouseover.htm&strip=0&vwsrc=0')
    driver.get('file:///C:/Users/WangWei/Pictures/python/seleniumtest/mouseover.htm')
    Write= driver.find_element_by_xpath('/html/body/form/input[1]')
    Blank=driver.find_element_by_xpath('/html/body/form/input[2]')
    value=driver.find_element_by_name('t1')
    
    # move_by_offset方法会从上一次的坐标位置开始
    ActionChains(driver).move_by_offset(51,44).perform()
    print(value.get_attribute('value'))

    # move_to_element用法，移动到指定位置
    ActionChains(driver).move_to_element(Write).perform()
    print(value.get_attribute('value'))

    # move_to_element用法，移动到指定位置
    ActionChains(driver).move_to_element(Blank).perform()
    print(value.get_attribute('value'))


    # 将坐标移动到指定位置 从Blank元素的正中心向右移动10，向上移动40
    ActionChains(driver).move_to_element_with_offset(Blank,10,-40).perform()
    print(value.get_attribute('value'))

    time.sleep(15)
    # 关闭
    driver.quit()


# 拖动演示
def dragDropMooTools():
    driver.get('http://sahitest.com/demo/dragDropMooTools.htm')

    drag=driver.find_element_by_xpath('/html/body/div[1]')
    div1=driver.find_element_by_xpath('/html/body/div[2]')
    div2=driver.find_element_by_xpath('/html/body/div[3]')
    div3=driver.find_element_by_xpath('/html/body/div[4]')
    div4=driver.find_element_by_xpath('/html/body/div[5]')

    #drag_and_drop鼠标左键点击source元素，然后移动到target元素释放鼠标按键
    ActionChains(driver).drag_and_drop(drag,div1).perform()

    #click_and_hold 长按住选择拖动元素，release 移动到指定元素 再松手，perform 执行
    ActionChains(driver).click_and_hold(drag).release(div2).perform()

    #click_and_hold 长按住选择拖动元素，move_to_element 移动到指定元素中心，release 松手，perform 执行
    ActionChains(driver).click_and_hold(drag).move_to_element(div3).release().perform()

    #click_and_hold 长按住选择拖动元素，move_by_offset 移动到指定坐标，release 松手，perform 执行
    ActionChains(driver).click_and_hold(drag).move_by_offset(400,150).release().perform()

    time.sleep(2)

    # 关闭浏览器
    driver.quit()


# 键盘按键案例
def keypress():
    driver.get('file:///C:/Users/WangWei/Pictures/python/seleniumtest/keypress.htm')

    
    key_up_radio =driver.find_element_by_id('r1')
    key_down_radio  =driver.find_element_by_id('r2')
    key_press_radio =driver.find_element_by_id('r3')

    enter = driver.find_elements_by_xpath('//form[@name="f1"]/input')[1]  # 输入框
    result = driver.find_elements_by_xpath('//form[@name="f1"]/input')[0]  # 监测结果


    # 检测SHIFT按键松开
    key_up_radio.click()
    enter.click()
    ActionChains(driver).key_down(Keys.SHIFT).key_up(Keys.SHIFT).perform()
    print(result.get_attribute('value'))
    time.sleep(1)

    # 检测ctel按键按下
    key_down_radio.click()
    enter.click()
    ActionChains(driver).key_down(Keys.CONTROL).key_up(Keys.CONTROL).perform()
    print(result.get_attribute('value'))
    time.sleep(1)
    
    # 模拟按下键盘a键
    key_press_radio.click()
    enter.click()
    ActionChains(driver).send_keys('a').perform()
    print(result.get_attribute('value'))

    time.sleep(3)
    # 关闭
    driver.quit()


# 复制粘贴案例
# 选择输入框，输入数据，复制数据，粘贴数据，松手，关闭浏览器
def keypress2():
    driver.get('file:///C:/Users/WangWei/Pictures/python/seleniumtest/Label.html')

    input1=driver.find_element_by_xpath('/html/body/label[1]/input')
    input2=driver.find_element_by_xpath('/html/body/label[2]/table/tbody/tr/td[2]/input')

    # 选择输入框
    input1.click()
    # 输入值
    ActionChains(driver).send_keys('test keys username').perform()
    # 选择值-复制
    ActionChains(driver).key_down(Keys.CONTROL).send_keys('a').send_keys('c').perform()
    time.sleep(1)
    # 粘贴值
    input2.click()
    ActionChains(driver).key_down(Keys.CONTROL).send_keys('v').release().perform()
    print('name:%s,password:%s' %(input1.get_attribute('value'),input2.get_attribute('value')))
    time.sleep(3)

    #关闭
    driver.quit()


def ctrl_f5():
    driver.get('file:///C:/Users/WangWei/Pictures/python/seleniumtest/Label.html')
    time.sleep(1)
    # ActionChains(driver).key_down(Keys.CONTROL).send_keys('a').perform()
    # ActionChains(driver).send_keys(Keys.CONTROL,'a').perform()
    # ActionChains(driver).key_down(Keys.CONTROL).key_down(Keys.F5).perform()
    for target_list in range(10):
        driver.refresh() #刷新方法
    

def boss():
    driver.get('https://login.zhipin.com/?ka=header-login')
    name= driver.find_element_by_xpath('/html/body/div[1]/div[2]/div[1]/div[2]/div/form/div[3]/span[2]/input')
    huadong=driver.find_element_by_xpath('/html/body/div[1]/div[2]/div[1]/div[2]/div/form/div[5]/div[1]/div/div[1]/span')
    huakuai=driver.find_element_by_id('nc_7_n1z')
    ActionChains(driver).click(name).send_keys('123456').perform()
    time.sleep(1)
    ActionChains(driver).move_to_element_with_offset(huakuai,10,0).perform()
    time.sleep(3)
    driver.quit()




def main():
    # buttom()
    # mouseover()
    # dragDropMooTools()
    # keypress()
    # keypress2()
    ctrl_f5()
    # boss()

if __name__ == "__main__":
    main()

time.sleep(100)


















# huadong=driver.find_element_by_xpath('/html/body/div[1]/div/div/div/div[2]/section[1]/article/div[2]/div[1]/section[1]/section[1]/div/div[1]/div[4]')
# ActionChains(driver).click_and_hold(on_element=huadong).perform()
#ActionChains(driver).move_to_element_with_offset(to_element=huadong,xoffset=276,yoffset=0)

# 寻找第一个frame
# driver.switch_to.frame(0)

# 寻找元素
# driver.find_element_by_xpath('/html/body/div[1]/div[1]/ul[1]/li[2]').click()

# 输入账号密码
# driver.find_element_by_xpath('/html/body/div[1]/div[2]/div[1]/div[3]/div/input').send_keys('17717842424')
# driver.find_element_by_xpath('/html/body/div[1]/div[2]/div[1]/div[4]/div/input').send_keys('123')


# 点击登陆
# driver.find_element_by_xpath('/html/body/div[1]/div[2]/div[1]/div[5]/a').click()



time.sleep(100)