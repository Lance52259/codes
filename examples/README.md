# Module基本介绍

模块是可以同时使用多个资源的容器，由目录中多个保存在一起的`.tf`或`.tf.json`文件中定义的资源组成。
模块是实现Terraform包装和重用资源配置的重要方式。

## 模块分类

模块主要分为两类:

+ **根模块**: 每个Terraform配置中都至少有一个模块，称之为根模块，该模块由主工作目录中的`.tf`或
  `.tf.json`文件中定义的各个资源组成。
+ **子模块**: 在子目录中定义的被另一个模块调用的模块，称为子模块，该模块由当前子模块目录中的`.tf`或
  `.tf.json`文件中定义的各个资源组成。子模块可以在同一个配置中多次调用，同样多个配置也可以共用一个子模块。

## 模块结构

一个项目通常由上述两种类型的模块构成，如构建一个CCE集群需要使用到网络模块和CCE模块，其中CCE模块对网络模块创建
的VPC和子网具有依赖性，因此其结构为:

```
huaweicloud-provider-example
|- main.tf
|- variables.tf
|- outputs.tf
|- modules
   |- network-example
   |  |- main.tf
   |  |- varibales.tf
   |  |- outputs.tf
   |- cce-example
      |- main.tf
      |- varibales.tf
      |- outputs.tf
```

## 模块声明

module块描述了父模块调用子模块的语法，其样例如下:

```hcl
module "cce" {
  source = "./modules/cce-example"

  vpc_id            = module.network.vpc_id
  network_id        = module.network.network_id
  security_group_id = module.network.security_group_id
}
```

module关键字代表声明对子模块的调用，关键字后面的标签是一个本地使用的名称，通过引用这个名称来引用这个模块的资源属
性。在模块声明主体中（`{`和`}`之间）的是模块的参数，包含: **source**、**version**、**inputs** 和
**meta-arguments**，其约束如下:

+ **source**参数在所有模块中都强制要求赋予。
+ 建议对Hashicorp官方发布的模块使用version参数控制引用版本。
+ 依赖于其他模块的资源参数都应该定义与**inputs**中，如上述示例中的**vpc_id**、**network_id**和
**security_group_id**。
+ 元参数适用于所有模块。

### source

所有的模块都需要一个`source`参数，这是一个由Terraform定义的元参数。它的值要么对应本地的模块配置路径，要么是可供下载使用的远程模块源（此值必须是普通字符串，不允许使用表达式）。
可以在多个模块中指定相同的源地址，以创建其中定义的资源的多个副本，可以赋予不同的变量值。

-> 添加、删除或修改模块后，必须重新运行`terraform init`，以便Terraform对其进行调整。默认情况下，此命令不会升级已安装模块的版本，需要使用`-upgrade`升级到最新版本。

### version

在使用各厂商在Hashicorp上发布的模块时，建议显式地声明可接受的版本号，以免产生因版本变化而导致的不必要变更。如使用AWS发布的consul模块，我们可以指定使用版本为`0.0.5`。

```
module "consul" {
  source  = "hashicorp/consul/aws"
  version = "0.0.5"

  servers = 3
}
```

version参数接受一个用于约束版本的字符串，配置此参数后terraform将使用符合约束的最新版本的模块。

### meta-arguments

除了**source**和**version**，Terraform还定义了一些对所有模块/资源生效的可选元参数:

+ **count**: 在单模块中创建模块的多个实例。
+ **for_each**: 在单模块中创建模块的多个实例。
+ **providers**: 将provider配置传递给子模块，如果没有显式指定，则子模块将继承默认provider。
+ **depends_on**: 定义模块之间的依赖关系。

目前module还不支持lifecycle参数。

## 如何引用子模块中的资源属性

由于模块中的资源被封装起来，外部无法直接访问，因此Terraform提供了子模块输出值声明的方式供用户有选择地将某些值向父模块传递。
例如在network模块中定了VPC，子网和安全组资源，在CCE模块中需要使用。则在network模块中将这三个值输出为三个变量供根模块调用并传递给CCE模块。

```
# network module
output "vpc_id" {
  value = huaweicloud_vpc.example.id
}

output "network_id" {
  value = huaweicloud_vpc_subnet.example.id
}

output "security_group_id" {
  value = huaweicloud_networking_secgroup.example.id
}
```

```
# root module
module "network" {
  source = "./modules/vpc-example"

  ...
}

module "cce" {
  source = "./modules/cce-example"

  vpc_id            = module.network.vpc_id
  network_id        = module.network.network_id
  security_group_id = module.network.security_group_id
}
```

## 如何建立依赖关系

module结构树中除了通过对输出值进行引用建立依赖关系外还可以通过depends_on元参数建立模块与模块间的依赖关系:

```
module "sfs_turbo" {
  source = "./modules/sfs-turbo-example"

  ...
}

module "ecs" {
  source = "./modules/ecs-example"

  depends_on = [module.sfs_turbo]

  ...
}
```

## 如何有效运用know after apply属性或参数建立依赖解决问题

在脚本开发过程中不免遇到需要中途修改某些文件内容并在后续的资源中引用修改后内容的场景，此时如果是通过file函数对文件
进行内容提取，那么其属性为know before apply，无法应用修改后的文本内容，因此需要通过调用一些具有know after apply属性的
参数将其从know before apply变为know after apply，例如在对ECS实例注入user_data时需要将shell脚本中的EXPORT_LOCATION
替换为SFS turbo的EXPORT_LOCATION，因此如果只在sfs turbo模块中对脚本进行修改，那么ECS实例注入的user_data便是修改前的
内容:

```
resource "huaweicloud_compute_instance" "example" {
  ...

  user_data = <<EOT
echo '${replace(file(var.local_file_path), "EXPORT_LOCATION", var.export_location)}' > ${var.remote_file_path}
EOT
}

# Throws an error that the value of the user_data field is inconsistent with the 'terraform apply'.
```

通过加入依赖解决此问题:

```
resource "huaweicloud_compute_instance" "example" {
  ...

  user_data = <<EOT
echo '${replace(file(var.local_file_path), "EXPORT_LOCATION", var.export_location)}' > ${var.remote_file_path}
EOT
}
```
