package controllers

import (
	"github.com/astaxie/beego"
	"mostar.com/api/models"
	"github.com/golang/protobuf/proto"
	"fmt"
	"encoding/base64"
)

type LoginController struct {
	beego.Controller
}

func (c *LoginController) Get() {
	name := c.GetString("name")
	// 编码
	userModel := &user.User{}
	userModel.UserId = proto.Int64(1)
	userModel.UserName = proto.String(name)
	userModel.Password = proto.String("P@ssw0rd")
	userModel.Telephone = proto.Int64(13800138000)
	userModel.Address = proto.String("广州市海珠区")
	data, _ := proto.Marshal(userModel)

	fmt.Println(data)

	// 解码
	newUserModel := &user.User{}
	proto.Unmarshal(data, newUserModel)
	fmt.Println(newUserModel.String())

	base64String := base64.StdEncoding.EncodeToString(data)

	fmt.Println(base64String)
	// 输出
	c.Ctx.WriteString(base64String)
}

type JSON struct {
	Output string
}
