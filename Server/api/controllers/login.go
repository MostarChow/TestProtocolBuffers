package controllers

import (
	"github.com/astaxie/beego"
	"github.com/golang/protobuf/proto"
	"fmt"
	"encoding/base64"
	"mostar.com/api/models"
)

type LoginController struct {
	beego.Controller
}

func (c *LoginController) Get() {
	name := c.GetString("name")
	// 编码
	data := getData(name)
	fmt.Println(data)

	// 解码
	newUserModel := &user.Output{}
	proto.Unmarshal(data, newUserModel)
	fmt.Println(newUserModel.String())

	base64String := base64.StdEncoding.EncodeToString(data)
	fmt.Println(base64String)
	
	// 输出
	c.Ctx.WriteString(base64String)
	//c.Ctx.Output.Body(data)
}

func (c *LoginController) Post()  {
	// 接收参数
	data := c.Ctx.Input.RequestBody
	// 将接收的base64转为二进制
	data, error := base64.StdEncoding.DecodeString(string(data))

	if error == nil {
		// 解码
		userModel := &user.Input{}
		proto.Unmarshal(data, userModel)

		// 获取数据
		name := userModel.GetAccount()
		outData := getData(name)

		base64String := base64.StdEncoding.EncodeToString(outData)

		// 输出
		c.Ctx.WriteString(base64String)
	} else {
		fmt.Println(error.Error())
	}
}

func getData(name string) ([]byte) {
	family := &user.FamilyGroup{
		Father:"哈哈哈",
		Mother:"呵呵呵",
	}

	array := []string{"我", "也", "不", "知", "道", "放", "什", "么", "好"}

	userModel := &user.Output{
		UserId:1,
		UserName:name,
		Password:"202cb962ac59075b964b07152d234b70",
		Telephone:13800138000,
		Address:"广州市海珠区",
		Family:family,
		Array:array,
	}
	data, _ := proto.Marshal(userModel)
	return data
}

