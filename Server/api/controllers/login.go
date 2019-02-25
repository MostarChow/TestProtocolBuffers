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
	userModel.UserId = proto.Int32(1)
	userModel.UserName = proto.String(name)
	data, _ := proto.Marshal(userModel)

	// 解码
	newUserModel := &user.User{}
	proto.Unmarshal(data, newUserModel)
	fmt.Println(newUserModel.String())

	// 输出
	c.Data["json"] = &JSON{Output:base64.StdEncoding.EncodeToString(data)}
	c.ServeJSON()
}

type JSON struct {
	Output string
}



