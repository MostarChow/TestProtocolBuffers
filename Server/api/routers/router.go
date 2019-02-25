package routers

import (
	"mostar.com/api/controllers"
	"github.com/astaxie/beego"
)

func init() {
    beego.Router("/", &controllers.MainController{})

    beego.Router("/login", &controllers.LoginController{})
}
