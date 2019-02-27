package controllers

import (
	"github.com/astaxie/beego"
	"github.com/golang/protobuf/proto"
	"mostar.com/api/models"
	"fmt"
	"encoding/base64"
)

type LoginController struct {
	beego.Controller
}

func (c *LoginController) Get() {
	name := c.GetString("name")
	// 编码
	data := getData(name)
	// 解码
	newUserModel := &user.Output{}
	proto.Unmarshal(data, newUserModel)
	// 转为base64
	base64String := base64.StdEncoding.EncodeToString(data)
	// 输出
	c.Ctx.WriteString(base64String)
}

func (c *LoginController) Post()  {
	// 接收参数
	data := c.Ctx.Input.RequestBody
	// 解码
	userModel := &user.Input{}
	error := proto.Unmarshal(data, userModel)
	if error == nil {
		// 获取数据
		name := userModel.GetAccount()
		outData := getData(name)
		fmt.Println(userModel.String())
		// 输出
		c.Ctx.Output.Body(outData)
	} else {
		msg := error.Error()
		c.Ctx.Output.Body([]byte(msg))
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

