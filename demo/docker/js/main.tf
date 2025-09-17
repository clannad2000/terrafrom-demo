##################################################################################################################################
#                          IAC目前所适配组件情况
#                          1.0.1 --------->【vm平台】- MySql8021 组件
#                          1.0.2 --------->【vm平台】- Oracle11g 组件
#                          1.0.3 --------->【vm平台】- PostgreSQL118 组件
#                          1.0.4 --------->【vm平台】- Mongodb42 组件
#
#                          2.0.1 --------->【openstack平台】- Opengauss3.0.3 组件
#                          2.0.2 --------->【openstack平台】- Nginx1.22 组件
#
#                          3.0.1 --------->【k8s平台】- namespace 组件
#                          3.0.2 --------->【k8s平台】- Redis6.2.5单节点 组件
#                          3.0.3 --------->【k8s平台】- Redis6.2.5集群 组件
#                          3.0.4 --------->【k8s平台】- ZooKeeper&kafka3.0.0集群 组件
#                          3.0.5 --------->【k8s平台】- ElasticSearch&Kibana7.9.3集群 组件
#                          3.0.6 --------->【k8s平台】- ClickHouse 组件
#                          3.1.1 --------->【k8s平台】- pod-deploy 组件
#
#                          4.1.1 --------->【阿里云平台】- VPC 组件
#                          4.1.2 --------->【阿里云平台】- SLB 组件
#                          4.1.3 --------->【阿里云平台】- Redis 组件
#                          4.1.4 --------->【阿里云平台】- RocketMQ 组件
#                          4.1.5 --------->【阿里云平台】- RDS 组件
#                          4.1.6 --------->【阿里云平台】- Mongodb 组件
#                          4.1.7 --------->【阿里云平台】- CR 组件
#                          4.1.8 --------->【阿里云平台】- ECS 组件
#                          4.1.9 --------->【阿里云平台】- Kubernetes 组件
#
#                          4.2.1 --------->【阿里云平台】- EDAS_NAMESPACE 组件
#                          4.2.2 --------->【阿里云平台】- EDAS_App 组件
#
#                          5.1.1 --------->【虚机服务】 - 虚机服务
#------------------------------------------模板使用说明
#    1、该模板提供了IAC所有适配的组件,根据需求保留所需要的组件module块
#    2、每个组件module块中的参数都分为
#         【固定值】        -> 不可修改
#         【平台配置值】       -> 一般情况不用修改，如果要修改得平台组确认
#         【平台配置值-需确认】      -> 需要根据实际情况修改，还得平台组确认
#         【自定义值】              -> 需要厂商根据实际情况修改
#    3、每个组件module块中的都标注了能够被其他module所引用的参数，其他module如果想要引用参考示例如下:
#         完整示例：       ${module.openstack-openguass.user}
#                  解释： ${module.} 为固定格式
#                                  openstack-openguass. 为指定的module名称
#                                                       user 为对应的module块中可用引用名称
#    4、厂商自定义服务使用如下1个模块模板
#                         3.1.1 --------->【k8s平台】- pod-deploy 组件
#       每有一个自定义服务便copy新增一个对应模块，每个模块的名称以'k8s-'开头，服务名全小写间隔符为'-' ，并添加注释且编号递增
#       每个自定义服务仅提供svc名称和端口给其他module引用
#       每个自定义服务中包含大量配置，需要根据实际情况填写和确认
#
########################## 1.0.1 ---------> MySql8021 ############################################################################
module "vsphere-mysql" { #【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source = "./modules/vsphere/mysql/"
  #【固定值】指定中文名称
  zh_name="MySql8021数据库"
  #【固定值】指定module类型
  module_type="db"
  #【固定值】指定平台连接信息
  vsphere = {
    cluster       = var.vsphere_cluster
    datacenter    = var.vsphere_datacenter
    vcenter       = var.vsphere_vcenter
    user          = var.vsphere_user
    password      = var.vsphere_password
    unverifiedSsl = var.vsphere_unverifiedSsl
  }
  #【固定值】指定主控节点连接信息
  control = {
    host     = module.vsphere.mysql_ip
    port     = var.control_port
    type     = var.control_type
    user     = var.control_user
    password = var.control_password
    insecure = var.control_insecure
  }
  #【固定值】指定模板连接信息
  db = {
    host_ip             = var.db_host_ip
    host_port           = var.db_host_port
    host_user           = var.db_host_user
    host_password       = var.db_host_password
  }
  #【平台配置值】指定vm使用的模板名称
  vm_template        = "template_mysql8021_yg_20230111"
  #【平台配置值】指定vm使用的数据中心名称
  vm_datastore       = "datastore2"
  #【平台配置值】指定vm使用的网络名称
  vm_network         = "VM Network"
  #【平台配置值】指定vm使用的网络掩码
  vm_netmask         = "24"
  #【平台配置值】指定vm使用的网关地址
  vm_gateway         = "192.168.130.254"
  #【平台配置值】指定vm使用的克隆类型
  vm_linkedClone     = "false"
  #【平台配置值】定义vm的DNS
  vm_dns             = "8.8.8.8"
  #【平台配置值】定义vm的域
  vm_domain          = "localhost"
  #【平台配置值】指定vm创建的超时时间(分钟)
  vm_timeout         = "20"
  #【平台配置值】等待vm创建时间(秒)
  wait_create_vm  = "300s"

  #【平台配置值-需确认】指定vm使用的ip地址
  vm_ip              = "192.168.130.249"
  #【平台配置值-需确认】定义vm的磁盘大小(GB)  *磁盘数量固定*
  vm_disk            = [50]
  #【平台配置值-需确认】定义vm的cpu大小(核)
  vm_cpu             = 2
  #【平台配置值-需确认】定义vm的内存大小(MB)
  vm_ram             = 2048
  #【自定义值】定义vm名称
  vm_name            = "iac-szxd-mysql8021"

  #【自定义值】定义db名称
  db_name            = "szxd"
  #【自定义值】定义db字符集
  db_character       = "utf8"
  #【自定义值】定义db排序规则
  db_collate         = "utf8_general_ci"
  #【自定义值】定义db用户名
  db_user            = "chita"
  #【自定义值】定义db密码
  db_password        = "Cc123!@#"
  #【自定义值】定义db端口
  db_port            = "33066"
  #【自定义值】定义db模式名(根据实际情况填写，没有则默认为""即可)
  db_schema          = ""
  #【***此组件为数据库需要初始化sql*** sql文件覆盖 ./modules/vsphere/mysql/ansible-playbook/files/init.sql 文件尽可能小一些】
  #
  #对其他module提供可用引用为如下
  #  host
  #  port
  #  user
  #  password
  #  name
  #  schema
}

########################## 1.0.2 ---------> Oracle11g ############################################################################
module "vsphere-oracle" { #【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source = "./modules/vsphere/oracle/"
  #【固定值】指定中文名称
  zh_name="Oracle11g数据库"
  #【固定值】指定module类型
  module_type="db"
  #【固定值】指定平台连接信息
  vsphere = {
    cluster       = var.vsphere_cluster
    datacenter    = var.vsphere_datacenter
    vcenter       = var.vsphere_vcenter
    user          = var.vsphere_user
    password      = var.vsphere_password
    unverifiedSsl = var.vsphere_unverifiedSsl
  }
  #【固定值】指定主控节点连接信息
  control = {
    host     = module.vsphere.oracle_ip
    port     = var.control_port
    type     = var.control_type
    user     = var.control_user
    password = var.control_password
    insecure = var.control_insecure
  }
  #【固定值】指定模板连接信息
  db = {
    host_ip             = var.db_host_ip
    host_port           = var.db_host_port
    host_user           = var.db_host_user
    host_password       = var.db_host_password
  }
  #【平台配置值】指定vm使用的模板名称
  vm_template        = "template_ora11g_yg_20230111"
  #【平台配置值】指定vm使用的数据中心名称
  vm_datastore       = "datastore2"
  #【平台配置值】指定vm使用的网络名称
  vm_network         = "VM Network"
  #【平台配置值】指定vm使用的网络掩码
  vm_netmask         = "24"
  #【平台配置值】指定vm使用的网关地址
  vm_gateway         = "192.168.130.254"
  #【平台配置值】指定vm使用的克隆类型
  vm_linkedClone     = "false"
  #【平台配置值】定义vm的DNS
  vm_dns             = "8.8.8.8"
  #【平台配置值】定义vm的域
  vm_domain          = "localhost"
  #【平台配置值】指定vm创建的超时时间(分钟)
  vm_timeout         = "20"
  #【平台配置值】等待vm创建时间(秒)
  wait_create_vm  = "300s"

  #【平台配置值-需确认】指定vm使用的ip地址
  vm_ip              = "192.168.130.249"
  #【平台配置值-需确认】定义vm的磁盘大小(GB)
  vm_disk            = [100,60,60]
  #【平台配置值-需确认】定义vm的cpu大小(核)
  vm_cpu             = 2
  #【平台配置值-需确认】定义vm的内存大小(MB)
  vm_ram             = 2048

  #【自定义值】定义vm名称
  vm_name            = "iac-szxd-oracle11g"
  #【自定义值】定义db名称
  db_name            = "szxd"
  #【自定义值】定义db字符集(根据实际情况填写，没有则默认为""即可)
  db_character       = "utf8"
  #【自定义值】定义db排序规则(根据实际情况填写，没有则默认为""即可)
  db_collate         = "utf8_general_ci"
  #【自定义值】定义db用户名
  db_user            = "chita"
  #【自定义值】定义db密码
  db_password        = "Cc123!@#"
  #【自定义值】定义db端口
  db_port            = "33066"
  #【自定义值】定义db模式名(根据实际情况填写，没有则默认为""即可)
  db_schema          = ""
  #【***此组件为数据库需要初始化sql*** sql文件覆盖 ./modules/vsphere/oracle/ansible-playbook/files/init.sql 文件尽可能小一些】
  #
  #对其他module提供可用引用为如下
  #  host
  #  port
  #  user
  #  password
  #  name
  #  schema
}

########################## 1.0.3 ---------> PostgreSQL118 ########################################################################
module "vsphere-postgresql" { #【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source = "./modules/vsphere/postgresql/"
  #【固定值】指定中文名称
  zh_name="PostgreSQL118数据库"
  #【固定值】指定module类型
  module_type="db"
  #【固定值】指定平台连接信息
  vsphere = {
    cluster       = var.vsphere_cluster
    datacenter    = var.vsphere_datacenter
    vcenter       = var.vsphere_vcenter
    user          = var.vsphere_user
    password      = var.vsphere_password
    unverifiedSsl = var.vsphere_unverifiedSsl
  }
  #【固定值】指定主控节点连接信息
  control = {
    host     = module.vsphere.postgresql_ip
    port     = var.control_port
    type     = var.control_type
    user     = var.control_user
    password = var.control_password
    insecure = var.control_insecure
  }
  #【平台配置值】指定vm使用的模板名称
  vm_template        = "template_pg118_yg_20230111"
  #【平台配置值】指定vm使用的数据中心名称
  vm_datastore       = "datastore2"
  #【平台配置值】指定vm使用的网络名称
  vm_network         = "VM Network"
  #【平台配置值】指定vm使用的网络掩码
  vm_netmask         = "24"
  #【平台配置值】指定vm使用的网关地址
  vm_gateway         = "192.168.130.254"
  #【平台配置值】指定vm使用的克隆类型
  vm_linkedClone     = "false"
  #【平台配置值】定义vm的DNS
  vm_dns             = "8.8.8.8"
  #【平台配置值】定义vm的域
  vm_domain          = "localhost"
  #【平台配置值】指定vm创建的超时时间(分钟)
  vm_timeout         = "20"
  #【平台配置值】等待vm创建时间(秒)
  wait_create_vm  = "300s"

  #【平台配置值-需确认】指定vm使用的ip地址
  vm_ip              = "192.168.130.249"
  #【平台配置值-需确认】定义vm的磁盘大小(GB)
  vm_disk            = [100,60,60]
  #【平台配置值-需确认】定义vm的cpu大小(核)
  vm_cpu             = 2
  #【平台配置值-需确认】定义vm的内存大小(MB)
  vm_ram             = 2048

  #【自定义值】定义vm名称
  vm_name            = "iac-szxd-postgresql118"
  #【自定义值】定义db数据存放目录
  db_path = "/usr/pgsql-11/data"
  #【自定义值】定义db数据库名
  db_base = "testdb"
  #【自定义值】定义db字符集
  db_character = "UTF8"
  #【自定义值】定义db排序规则
  db_collate = "en_US.UTF-8"
  #【自定义值】定义db字符类型
  db_ctype = "en_US.UTF-8"
  #【自定义值】定义db用户名
  db_user = "test"
  #【自定义值】定义db密码
  db_password = "123456"
  #【自定义值】定义db端口
  db_port = "30323"
  #【自定义值】定义db模式名(根据实际情况填写，没有则默认为""即可)
  db_schema = "testschema"
  #【***此组件为数据库需要初始化sql*** sql文件覆盖 ./modules/vsphere/postgresql/ansible-playbook/files/init.sql 文件尽可能小一些】
  #
  #对其他module提供可用引用为如下
  #  host
  #  port
  #  user
  #  password
  #  name
  #  schema
}

########################## 1.0.4 ---------> Mongodb42 ############################################################################
module "vsphere-mongodb" { #【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source = "./modules/vsphere/mongodb/"
  #【固定值】指定中文名称
  zh_name="Mongodb42数据库"
  #【固定值】指定module类型
  module_type="db"
  #【固定值】指定平台连接信息
  vsphere = {
    cluster       = var.vsphere_cluster
    datacenter    = var.vsphere_datacenter
    vcenter       = var.vsphere_vcenter
    user          = var.vsphere_user
    password      = var.vsphere_password
    unverifiedSsl = var.vsphere_unverifiedSsl
  }
  #【固定值】指定主控节点连接信息
  control = {
    host     = module.vsphere.mongodb_ip
    port     = var.control_port
    type     = var.control_type
    user     = var.control_user
    password = var.control_password
    insecure = var.control_insecure
  }
  #【平台配置值】指定vm使用的模板名称
  vm_template        = "template_mongodb42_yg_20230111"
  #【平台配置值】指定vm使用的数据中心名称
  vm_datastore       = "datastore2"
  #【平台配置值】指定vm使用的网络名称
  vm_network         = "VM Network"
  #【平台配置值】指定vm使用的网络掩码
  vm_netmask         = "24"
  #【平台配置值】指定vm使用的网关地址
  vm_gateway         = "192.168.130.254"
  #【平台配置值】指定vm使用的克隆类型
  vm_linkedClone     = "false"
  #【平台配置值】定义vm的DNS
  vm_dns             = "8.8.8.8"
  #【平台配置值】定义vm的域
  vm_domain          = "localhost"
  #【平台配置值】指定vm创建的超时时间(分钟)
  vm_timeout         = "20"
  #【平台配置值】等待vm创建时间(秒)
  wait_create_vm  = "300s"

  #【平台配置值-需确认】指定vm使用的ip地址
  vm_ip              = "192.168.130.249"
  #【平台配置值-需确认】定义vm的磁盘大小(GB)
  vm_disk            = [100,60,60]
  #【平台配置值-需确认】定义vm的cpu大小(核)
  vm_cpu             = 2
  #【平台配置值-需确认】定义vm的内存大小(MB)
  vm_ram             = 2048

  #【自定义值】定义vm名称
  vm_name            = "iac-szxd-mongodb42"
  #【自定义值】定义db名称
  db_database = "testdb"
  #【自定义值】定义db排序规则
  db_collate  = "en_US"
  #【自定义值】定义db排序强度
  db_strength = "1"
  #【自定义值】定义db用户名
  db_user     = "test"
  #【自定义值】定义db密码
  db_password = "123456"
  #【自定义值】定义db端口
  db_port     = "54023"
  #【自定义值】定义db模式名(根据实际情况填写，没有则默认为""即可)
  db_schema   = ""
  #【***此组件为数据库需要初始化sql*** sql文件覆盖 ./modules/vsphere/mongodb/ansible-playbook/files/init.sql 文件尽可能小一些】
  #
  #对其他module提供可用引用为如下
  #  host
  #  port
  #  user
  #  password
  #  name
  #  schema
}

########################## 2.0.1 ---------> Opengauss3.0.3 #######################################################################
module "openstack-openguass" { #【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source = "./modules/openstack/openguas/"
  #【固定值】指定中文名称
  zh_name     = "Opengauss3.0.3数据库"
  #【固定值】指定module类型
  module_type = "db"
  #【固定值】指定平台连接信息
  openstack = {
    user_name   =       var.openstack.user_name
    tenant_name =       var.openstack.tenant_name
    password    =       var.openstack.password
    auth_url    =       var.openstack.auth_url
    region      =       var.openstack.region
  }
  #【固定值】指定主控节点连接信息
  control = {
    host     = var.control_host
    port     = var.control_port
    type     = var.control_type
    user     = var.control_user
    password = var.control_password
    insecure = var.control_insecure
  }
  #【固定值】指定模板连接信息
  db = {
    host_ip             = var.db_host_ip
    host_port           = var.db_host_port
    host_user           = var.db_host_user
    host_password       = var.db_host_password
  }
  #【固定值】指定实例密钥对名称
  instance_key_pair     =  var.instance.key_pair
  #【平台配置值】指定实例镜像模板名称
  instance_image_name   =  "centos75_20210303_10022_ygpt"
  #【平台配置值】指定实例网络名称
  instance_network_name =  "ext_20.46.113.0/24"
  #【平台配置值】等待openguass实例创建时间(秒)
  wait_openstack_create = "300s"

  #【平台配置值-需确认】指定实例规格名称
  instance_flavor_name  =  "4-8-50"
  #【自定义值】指定实例名称
  instance_name         =  "iac-sdyjgl-openstack"
  #【自定义值】定义db名称
  db_name               = "szxd"
  #【自定义值】定义db字符集
  db_character          = "utf8"
  #【自定义值】定义db排序规则
  db_collate            = "utf8_general_ci"
  #【自定义值】定义db用户名
  db_user               = "chita"
  #【自定义值】定义db密码
  db_password           = "Cc123!@#"
  #【自定义值】定义db端口
  db_port               = "33066"
  #【自定义值】定义db模式名(根据实际情况填写，没有则默认为""即可)
  db_schema             = ""
  #【***此组件为数据库需要初始化sql*** sql文件覆盖 ./modules/vsphere/mysql/ansible-playbook/files/init.sql 文件尽可能小一些】
  #
  #对其他module提供可用引用为如下
  #  host
  #  port
  #  user
  #  password
  #  name
  #  schema
}

########################## 2.0.2 ---------> Nginx1.22 ############################################################################
module "openstack-nginx" { #【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source = "./modules/openstack/nginx"
  #【固定值】指定中文名称
  zh_name     = "Nginx1.22"
  #【固定值】指定module类型
  module_type = "nginx"
  #【固定值】指定平台连接信息
  openstack = {
    user_name   =       var.openstack.user_name
    tenant_name =       var.openstack.tenant_name
    password    =       var.openstack.password
    auth_url    =       var.openstack.auth_url
    region      =       var.openstack.region
  }
  #【固定值】指定模板连接信息
  control = {
    host     = module.vsphere.nginx_ip
    port     = var.control_port
    type     = var.control_type
    user     = var.control_user
    password = var.control_password
    insecure = var.control_insecure
  }

  #【固定值】指定实例密钥对名称
  instance_key_pair     =  var.instance.key_pair
  #【平台配置值】指定实例镜像模板名称
  instance_image_name   =  "centos75_20210303_10022_ygpt"
  #【平台配置值】指定实例网络名称
  instance_network_name =  "ext_20.46.113.0/24"
  #【平台配置值】等待openguass实例创建时间(秒)
  wait_openstack_create = "300s"

  #【平台配置值-需确认】指定实例规格名称
  instance_flavor_name  =  "4-8-50"
  #【自定义值】指定实例名称
  instance_name         =  "iac-sdyjgl-openstack"
  #【***此组件需要涉及配置文件修改*** 配置文件覆盖 ./modules/openstack/nginx/ansible-playbook/files/nginx.conf 需确认配置文件可用】
  #对其他module提供可用引用为如下
  #  host
}

########################## 3.0.1 ---------> namespace ############################################################################
module "k8s-namespace" { #【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source = "./modules/k8s/namespace/"
  #【固定值】指定中文名称
  zh_name     = "k8s命名空间"
  #【固定值】指定module类型
  module_type = "microservice"
  #【固定值】指定平台连接信息
  kubernetes = {
    host                         =   var.kubernetes.host
    client_certificate           =   var.kubernetes.client_certificate
    client_key                   =   var.kubernetes.client_key
    cluster_ca_certificate       =   var.kubernetes.cluster_ca_certificate
  }

  #【自定义值】定义k8s命名空间名称
  kubernetes_namespace                    =   "iac-sdyj"
  #
  #对其他module提供可用引用为如下
  #  name (命名空间名称)
}

########################## 3.0.2 ---------> Redis6.2.5单节点 #####################################################################
module "k8s-redis" {#【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source = "./modules/k8s/redis/"
  #【固定值】指定中文名称
  zh_name     = "Redis6.2.5单节点"
  #【固定值】指定module类型
  module_type = "db"
  #【固定值】指定平台连接信息
  kubernetes = {
    host                         =   var.kubernetes.host
    client_certificate           =   var.kubernetes.client_certificate
    client_key                   =   var.kubernetes.client_key
    cluster_ca_certificate       =   var.kubernetes.cluster_ca_certificate
  }

  #【平台配置值】等待namespace创建时间(秒)
  wait_namespace_create = "60s"

  #【平台配置值-需确认】指定redis的名称
  redis_name      = "iac-redis"
  #【平台配置值-需确认】指定redis的命名空间名称
  redis_namespace     = module.k8s-namespace.name
  #【平台配置值-需确认】指定redis最大的cpu资源
  redis_limits_cpu      = "4000m"
  #【平台配置值-需确认】指定redis最大的内存资源
  redis_limits_memory   = "8Gi"
  #【平台配置值-需确认】指定redis请求的cpu资源
  redis_requests_cpu    = "1000m"
  #【平台配置值-需确认】指定redis请求的内存资源
  redis_requests_memory =  "2Gi"
  #【平台配置值-需确认】指定redisExporter最大的cpu资源
  redisExporter_limits_cpu      = "1000m"
  #【平台配置值-需确认】指定redisExporter最大的内存资源
  redisExporter_limits_memory   = "1Gi"
  #【平台配置值-需确认】指定redisExporter请求的cpu资源
  redisExporter_requests_cpu    = "100m"
  #【平台配置值-需确认】指定redisExporter请求的内存资源
  redisExporter_requests_memory = "128Mi"
  #【平台配置值-需确认】指定redis请求的存储空间大小
  redis_requests_storage  = "5Gi"
  #【平台配置值-需确认】指定redis的密码
  redis_password          = base64encode("Cc123!@#")
  #
  #对其他module提供可用引用为如下
  #  host (k8s中svc名称)
  #  port (k8s中svc端口)
  #  user
  #  password

}



########################## 3.0.3 ---------> Redis6.2.5集群 #######################################################################
module "k8s-rediscluster" { #【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source = "./modules/k8s/rediscluster/"
  #【固定值】指定中文名称
  zh_name     = "Redis6.2.5集群"
  #【固定值】指定module类型
  module_type = "db"
  #【固定值】指定平台连接信息
  kubernetes = {
    host                         =   var.kubernetes.host
    client_certificate           =   var.kubernetes.client_certificate
    client_key                   =   var.kubernetes.client_key
    cluster_ca_certificate       =   var.kubernetes.cluster_ca_certificate
  }

  #【平台配置值】等待namespace创建时间(秒)
  wait_namespace_create  = "60s"

  #【平台配置值-需确认】指定rediscluster的名称
  rediscluster_name      = "iac-rediscluster"
  #【平台配置值-需确认】指定rediscluster的命名空间名称
  rediscluster_namespace = module.k8s-namespace.name
  #【平台配置值-需确认】指定redis最大的cpu资源
  redis_limits_cpu      = "4000m"
  #【平台配置值-需确认】指定redis最大的内存资源
  redis_limits_memory   = "8Gi"
  #【平台配置值-需确认】指定redis请求的cpu资源
  redis_requests_cpu    = "1000m"
  #【平台配置值-需确认】指定redis请求的内存资源
  redis_requests_memory =  "2Gi"
  #【平台配置值-需确认】指定redisExporter最大的cpu资源
  redisExporter_limits_cpu      = "1000m"
  #【平台配置值-需确认】指定redisExporter最大的内存资源
  redisExporter_limits_memory   = "1Gi"
  #【平台配置值-需确认】指定redisExporter请求的cpu资源
  redisExporter_requests_cpu    = "100m"
  #【平台配置值-需确认】指定redisExporter请求的内存资源
  redisExporter_requests_memory = "128Mi"
  #【平台配置值-需确认】指定redis请求的存储空间大小
  redis_requests_storage  = "5Gi"
  #【平台配置值-需确认】指定redis的密码
  redis_password          = base64encode("Cc123!@#")
  #
  #对其他module提供可用引用为如下
  #  host (k8s中svc名称)
  #  port (k8s中svc端口)
  #  user
  #  password

}

########################## 3.0.4 ---------> ZooKeeper&kafka3.0.0集群 #############################################################
module "k8s-kafka-zookeeper" { #【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source = "./modules/k8s/kafka-zookeeper/"
  #【固定值】指定中文名称
  zh_name     = "ZooKeeper&kafka3.0.0集群"
  #【固定值】指定module类型
  module_type = "middle"
  #【固定值】指定平台连接信息
  kubernetes = {
    host                         =   var.kubernetes.host
    client_certificate           =   var.kubernetes.client_certificate
    client_key                   =   var.kubernetes.client_key
    cluster_ca_certificate       =   var.kubernetes.cluster_ca_certificate
  }

  #【平台配置值】等待namespace创建时间(秒)
  wait_namespace_create  = "60s"
  #【平台配置值-需确认】指定ZooKeeper&kafka集群名称
  kz_name                = "kafka-3-0-0-20240329-1"
  #【平台配置值-需确认】指定ZooKeeper&kafka集群的命名空间
  kz_namespace           = module.k8s-namespace.name


  #【平台配置值-需确认】指定kafka最大的cpu资源
  kafka_cpu_limits      = "1"
  #【平台配置值-需确认】指定kafka最大的内存资源
  kafka_memory_limits   = "1Gi"
  #【平台配置值-需确认】指定kafka请求的cpu资源
  kafka_cpu_requests    = "1"
  #【平台配置值-需确认】指定kafka请求的内存资源
  kafka_memory_requests = "1Gi"

  #【平台配置值-需确认】指定kafka的JVM初始堆内存大小
  kafka_jvm_xms = "5G"
  #【平台配置值-需确认】指定kafka的JVM最大堆内存大小
  kafka_jvm_xmx = "5G"
  #【平台配置值-需确认】指定kafka请求的存储空间大小
  kafka_storage = "5G"

  #【平台配置值-需确认】指定zookeeper最大的cpu资源
  zookeeper_cpu_limits      = "1"
  #【平台配置值-需确认】指定zookeeper最大的内存资源
  zookeeper_memory_limits   = "1Gi"
  #【平台配置值-需确认】指定zookeeper请求的cpu资源
  zookeeper_cpu_requests    = "1"
  #【平台配置值-需确认】指定zookeeper请求的内存资源
  zookeeper_memory_requests = "1Gi"

  #【平台配置值-需确认】指定zookeeper的JVM初始堆内存大小
  zookeeper_jvm_xms         = "5G"
  #【平台配置值-需确认】指定zookeeper的JVM最大堆内存大小
  zookeeper_jvm_xmx         = "5G"
  #【平台配置值-需确认】指定zookeeper请求的存储空间大小
  zookeeper_storage         = "5G"

  #【平台配置值-需确认】指定eotlsSidecar最大的cpu资源
  eotlsSidecar_cpu_limits      = "1"
  #【平台配置值-需确认】指定eotlsSidecar最大的内存资源
  eotlsSidecar_memory_limits   = "1Gi"
  #【平台配置值-需确认】指定eotlsSidecar请求的cpu资源
  eotlsSidecar_cpu_requests    = "1"
  #【平台配置值-需确认】指定eotlsSidecar请求的内存资源
  eotlsSidecar_memory_requests = "1Gi"

  #【平台配置值-需确认】指定eotopicOperator最大的cpu资源
  eotopicOperator_cpu_limits      = "1"
  #【平台配置值-需确认】指定eotopicOperator最大的内存资源
  eotopicOperator_memory_limits   = "1Gi"
  #【平台配置值-需确认】指定eotopicOperator请求的cpu资源
  eotopicOperator_cpu_requests    = "1"
  #【平台配置值-需确认】指定eotopicOperator请求的内存资源
  eotopicOperator_memory_requests = "1Gi"

  #【平台配置值-需确认】指定eouserOperator最大的cpu资源
  eouserOperator_cpu_limits      = "1"
  #【平台配置值-需确认】指定eouserOperator最大的内存资源
  eouserOperator_memory_limits   = "1Gi"
  #【平台配置值-需确认】指定eouserOperator请求的cpu资源
  eouserOperator_cpu_requests    = "1"
  #【平台配置值-需确认】指定eouserOperator
  eouserOperator_memory_requests = "1Gi"

  #【平台配置值-需确认】指定kafkaExporter最大的cpu资源
  kafkaExporter_cpu_limits      = "1"
  #【平台配置值-需确认】指定kafkaExporter最大的内存资源
  kafkaExporter_memory_limits   = "1Gi"
  #【平台配置值-需确认】指定kafkaExporter请求的cpu资源
  kafkaExporter_cpu_requests    = "1"
  #【平台配置值-需确认】指定kafkaExporter请求的内存资源
  kafkaExporter_memory_requests = "1Gi"
  #
  #对其他module提供可用引用为如下
  #  host (k8s中svc名称)
  #  port (k8s中svc端口)
  #  user
  #  password

}

########################## 3.0.5 ---------> ElasticSearch&Kibana7.9.3集群 ########################################################
module "k8s-es-ki" { #【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source      = "./modules/k8s/es-ki/"
  #【固定值】指定中文名称
  zh_name     = "ElasticSearch&Kibana7.9.3集群"
  #【固定值】指定module类型
  module_type = "middle"
  #【固定值】指定平台连接信息
  kubernetes  = {
    host                         =   var.kubernetes.host
    client_certificate           =   var.kubernetes.client_certificate
    client_key                   =   var.kubernetes.client_key
    cluster_ca_certificate       =   var.kubernetes.cluster_ca_certificate
  }

  #【平台配置值】等待namespace创建时间(秒)
  wait_namespace_create  = "60s"
  #【平台配置值-需确认】指定ElasticSearch&Kibana7.9.3集群名称
  eski_name              = "iac-eski"
  #【平台配置值-需确认】指定ElasticSearch&Kibana7.9.3集群的命名空间
  eski_namespace         = module.k8s-namespace.name

  #【平台配置值-需确认】指定ElasticSearch_master请求的存储空间大小
  es_master_storage         = "10Gi"
  #【平台配置值-需确认】指定ElasticSearch_master的存储名称
  es_master_storagename     = "rook-ceph-block"
  #【平台配置值-需确认】指定ElasticSearch_sysctl最大的cpu资源
  es_sysctl_cpu_limits      = "1"
  #【平台配置值-需确认】指定ElasticSearch_sysctl最大的内存资源
  es_sysctl_memory_limits   = "1Gi"
  #【平台配置值-需确认】指定ElasticSearch_sysctl请求的cpu资源
  es_sysctl_cpu_requests    = "1"
  #【平台配置值-需确认】指定ElasticSearch_sysctl请求的内存资源
  es_sysctl_memory_requests = "1GI"
  #【平台配置值-需确认】指定ElasticSearch的JVM初始堆内存大小
  es_xms                    = "8g"
  #【平台配置值-需确认】指定ElasticSearch的JVM最大堆内存大小
  es_xmx                    = "8g"
  #【平台配置值-需确认】指定ElasticSearch_data请求的存储空间大小
  es_data_storage           = "10Gi"
  #【平台配置值-需确认】指定ElasticSearch_data的存储名称
  es_data_storagename       = "rook-ceph-block"
  #【平台配置值-需确认】指定ElasticSearch最大的cpu资源
  es_cpu_limits             = "6"
  #【平台配置值-需确认】指定ElasticSearch最大的内存资源
  es_memory_limits          = "16Gi"
  #【平台配置值-需确认】指定ElasticSearch请求的cpu资源
  es_cpu_requests           = "6"
  #【平台配置值-需确认】指定ElasticSearch请求的内存资源
  es_memory_requests        = "16Gi"

  #【平台配置值-需确认】指定Kibana最大的cpu资源
  kb_cpu_limits             = "2"
  #【平台配置值-需确认】指定Kibana最大的内存资源
  kb_memory_limits          = "4Gi"
  #【平台配置值-需确认】指定Kibana请求的cpu资源
  kb_cpu_requests           = "2"
  #【平台配置值-需确认】指定Kibana请求的内存资源
  kb_memory_requests        = "4Gi"
  #
  #对其他module提供可用引用为如下
  #  host (k8s中svc名称)
  #  port (k8s中svc端口)
  #  user
  #  password
}

########################## 3.0.6 ---------> ClickHouse 组件 ############################################################
module "k8s-clickhouse" {  #【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source = "./modules/k8s/clickhouse"
  #【固定值】指定中文名称
  zh_name     = "clickhouse集群"
  #【固定值】指定module类型
  module_type = "db"
  #【固定值】指定平台连接信息
  kubernetes = {
    host                   = var.kubernetes_host
    client_certificate     = var.kubernetes_client_certificate
    client_key             = var.kubernetes_client_key
    cluster_ca_certificate = var.kubernetes_cluster_ca_certificate
  }
  #【自定义值】指定clickhouse集群名称
  clickhouse_name            = "clickhouse-module"
  #【自定义值】指定clickhouse集群的命名空间
  clickhouse_namespace       = var.kubernetes_namespace
  #【自定义值】指定clickhouse集群的密码
  clickhouse_password        = "Qq123!@#"
  #【自定义值】指定clickhouse集群最大的cpu资源
  clickhouse_cpu_limits      = "2"
  #【自定义值】指定clickhouse集群最大的内存资源
  clickhouse_memory_limits   = "2Gi"
  #【自定义值】指定clickhouse集群请求的cpu资源
  clickhouse_cpu_requests    = "2"
  #【自定义值】指定clickhouse集群请求的内存资源
  clickhouse_memory_requests = "1Gi"
  #【自定义值】指定clickhouse集群的存储类型
  clickhouse_storage         = "rook-ceph-block"
  #【自定义值】指定clickhouse_data的存储空间
  clickhouse_data_storage    = "1Gi"
  #【自定义值】指定clickhouse_zk集群最大的cpu资源
  clickhouse_zk_cpu_limits      = "2"
  #【自定义值】指定clickhouse_zk集群最大的内存资源
  clickhouse_zk_memory_limits   = "1Gi"
  #【自定义值】指定clickhouse_zk集群请求的cpu资源
  clickhouse_zk_cpu_requests    = "1"
  #【自定义值】指定clickhouse_zk集群请求的内存资源
  clickhouse_zk_memory_requests = "512Mi"
  #【自定义值】指定clickhouse_zk集群的存储类型
  clickhouse_zk_storage_class   = "rook-ceph-block"
  #【自定义值】指定clickhouse_zk集群的存储空间
  clickhouse_zk_storage         = "1Gi"
}

########################## 3.1.1 ---------> pod ########################################################################
module "abc" { #【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source                  = "./modules/k8s/pod/"
  #【自定义值】指定中文名称
  zh_name                 = ""
  #【固定值】指定module类型
  module_type             = "microservice"
  #【固定值】指定层级
  index                   = "3"
  #【固定值】指定引用目标
  parent                  = "-"
  #【固定值】指定平台连接信息
  kubernetes              = {
    host                         =   var.kubernetes_host
    client_certificate           =   var.kubernetes_client_certificate
    client_key                   =   var.kubernetes_client_key
    cluster_ca_certificate       =   var.kubernetes_cluster_ca_certificate
  }
  #【自定义值-需确认】指定pod的命名空间名称
  namespace               = var.kubernetes_namespace
  #【自定义值-需确认】指定pod的副本数
  replicas                = 1
  #【自定义值-需确认】指定容器的端口
  containerPort           = [
    {name = "http",port="8080"}
  ]
  #【自定义值-需确认】指定pod最大的cpu资源
  limitsCpu               = "2000m"
  #【自定义值-需确认】指定pod最大的内存资源
  limitsMemory            = "8000Mi"
  #【自定义值-需确认】指定pod默认请求的cpu资源
  requestsCpu             = "1000m"
  #【自定义值-需确认】指定pod默认请求的x内存资源
  requestsMemory          = "2000Mi"
  #【自定义值】指定是否添加svc（创建为true，不创建为false 默认创建的svc的名字和服务的pod名一致）
  svc_enable              = true
  #【自定义值】指定svc类型（填写NodePort或ClusterIP，不创建则不填或保持默认）
  svcType                 = "ClusterIP"
  #【自定义值-需确认】指定pod的svc（svcPort为svc端口，svcTargetPort为目标端口，nodePort存在则填写不存在则nodePort = "",随机生成nodePort则填0）
  svc  = [
    { name = "http",svcPort = "8080",svcTargetPort= "8080",nodePort = 0 }
  ]
  #【自定义值-需确认】指定svc的ip地址
  svc_clusterip           = ""
  #【自定义值-需确认】指定pod的host配置(如果没有则填'[]')
  hostAliases             = []
  #【自定义值】指定pod的元数据名称
  metadataName            = "abc"
  #【自定义值】指定pod的镜像名称
  containerImage          = "hub.js.sgcc.com.cn/qiguanyu/abc:1.1.10"
  #【自定义值】指定pod的命令
  #基于可观测平台监控的配置，如需修改请看以下注释
  #-DAPP_NAME: 为应用系统的唯一别名，可以从统一权限获取或自主定义，一串字符，唯一即可；
  #-Dotel.resource.attributes=app.name: 同APP_NAME，数值一致，新探针版本适配；
  #-Dotel.service.name : 需要与I6000台账中deployment名称字段一致，在脚本是metadataName
  containerCommand        = []
  #【自定义值】指定pod的参数
  containerArgs           = []
  #【自定义值】指定是否创建liveness探针（创建为true，不创建为false）
  livenessProbe_enable                   = false
  #【自定义值】指定探针当Pod成功启动且检查失败时，将在放弃之前尝试的次数
  livenessProbe_failureThreshold         = 3
  #【自定义值】指定容器启动和探针启动之间的秒数
  livenessProbe_initialDelaySeconds      = 240
  #【自定义值】指定探针检查的频率（以秒为单位）
  livenessProbe_periodSeconds            = 10
  #【自定义值】指定探针失败后检查成功的最小连续成功次数
  livenessProbe_successThreshold         = 1
  #【自定义值】指定探针超时重启秒数
  livenessProbe_timeoutSeconds           = 3
  #【自定义值】指定探针方式（httpGet、tcpSocket）
  livenessProbe_type                     = "tcpSocket"
  #【自定义值】指定探针端口
  livenessProbe_port                     = 8080
  #【自定义值】指定探针探测路径（httpget方式，默认为空）
  livenessProbe_path                     = ""
  #【自定义值】指定探针模式（没有则填空）
  livenessProbe_scheme                   = "HTTP"
  #【自定义值】指定是否创建readiness探针（创建为true，不创建为false）
  readinessProbe_enable                  = false
  #【自定义值】指定探针当Pod成功启动且检查失败时，将在放弃之前尝试的次数
  readinessProbe_failureThreshold        = 10
  #【自定义值】指定容器启动和探针启动之间的秒数
  readinessProbe_initialDelaySeconds     = 200
  #【自定义值】指定探针检查的频率（以秒为单位）
  readinessProbe_periodSeconds           = 10
  #【自定义值】指定探针失败后检查成功的最小连续成功次数
  readinessProbe_successThreshold        = 1
  #【自定义值】指定探针超时重启秒数
  readinessProbe_timeoutSeconds          = 1
  #【自定义值】指定探针方式（httpGet、tcpScoket）
  readinessProbe_type      = "tcpSocket"
  #【自定义值】指定探针端口
  readinessProbe_port      = 3000
  #【自定义值】指定探针探测路径（httpget方式，默认为空）
  readinessProbe_path      = ""
  #【自定义值】指定探针模式（没有填空）
  readinessProbe_scheme    = "HTTP"
  #【自定义值】指定是否创建初始化容器
  init_container_enable    = false
  #【自定义值】指定初始化容器启动命令
  init_containerCommand    = [
    "/bin/sh",
    "-c"
  ]
  #【自定义值】指定初始化容器镜像
  init_containerImage     = "abc/edf:1.1.1"
  #【自定义值】指定初始化容器名称
  init_name               = "agent"
  #【自定义值】指定初始化容器挂载（）
  init_volumeMounts       = [
    { name = "agent",path ="/agent"}
  ]
  #【自定义值】指定pod容器挂载（没有则填空）
  #volumeMounts            = [
  #  { name = "abc",mountPath="/home/config",subPath="config"},
  #  { name = "abc",mountPath="/home/"}
  #]
  #例：如果不使用则删除上面例子，如果使用就删除下面的空示例
  volumeMounts = []
  #【自定义值】指定pod挂载（没有则填空）,name为挂载名称，type为挂载类型（configMap、persistentVolumeClaim、hostPath）
  #configmap类型包含key、configmap_name、path，key为原文件名称，path为挂载后文件的名称，configmap_name为configmap名称
  #persistentVolumeClaim类型包含claimName，claimName为pvc名称
  #volumes = [
  #  { name="abc", type="configMap", configmap_name = "abc"},
  #  { name="abc", type="persistentVolumeClaim", claimName="wldaxt-pvc"},
  #  { name="abc", type="hostPath", path ="/root/.kube"},
  #  { name="abc", type="nfs" , server = "1.2.3.4" , path ="/abc" }
  #  { name="abc", type="emptyDir" }
  #]
  #例：如果不使用则删除上面例子，如果使用就删除下面的空示例
  volumes = []
  #【自定义值】指定是否添加ingress（创建为true，不创建为false，默认创建的ingress的名字和服务的pod名一致）
  ingress_enable          = true
  #【自定义值】指定ingress的class名称，
  ingress_class_name      = ""
  #【自定义值】指定ingress的host名称
  hostname                = ""
  #【自定义值】指定ingress的配置
  annotations             = {
    "kubernetes.io/ingress.class" = "jiangning3-ingress"
    "nginx.ingress.kubernetes.io/affinity" = "cookie"
    "nginx.ingress.kubernetes.io/session-cookie-hash" = "sha1"
    "nginx.ingress.kubernetes.io/session-cookie-name" = "INGRESSCOOKIE"
    "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
    "nginx.ingress.kubernetes.io/upstream-hash-by" = "sticky"
    "nginx.ingress.kubernetes.io/proxy-body-size" = "50M"
  }
  #【自定义值】指定ingress的path情况，path指定跳转路径，serviceName指定svc的名称，servicePort指定端口，pathType
  paths                   = [
    { path ="/daxt-admin", serviceName ="abc", servicePort ="8080"}
  ]
  #【自定义值】指定ingress的tls协议
  ingress_tls = []
  #例：
  #ingress_tls = [
  #  { tls_hosts = ["abc.com.cn"], tls_secret_name = "abc.com.cn" }
  #]
  #【自定义值】指定是否创建configmap（创建为true，不创建为false，默认创建的configmap的名字和服务的pod名一致）
  configmap_enable        = true
  #【自定义值】指定configmap的配置名称以及配置信息（规定配置信息导入到了yml文件里）
  #config_file             = [
  #  { key ="application.yml", file ="abc-application.yml"},
  #  { key ="application-prod.yml", file ="abc-application-prod.yml"}
  #]
  #config_data              = [
  #  { key = "DRONE_NAMESPACE_DEFAULT", value = "custom-namespace" },
  #  { key = "DRONE_RPC_HOST",          value = "custom-drone:80" },
  #  { key = "DRONE_RPC_PROTO",         value = "https" },
  #  { key = "DRONE_RPC_SECRET",        value = "new_secret" },
  #  { key = "DRONE_IMAGE_PLACEHOLDER", value = "hub.js.sgcc.com.cn/yingxiaoyu/custom-placeholder:1.1.1" }
  #]
  #没有configmap，如果不使用则删除上面例子，如果使用就删除下面的空示例
  config_file = []
  config_data = []
  #【自定义值】指定是否创建secret（创建为true，不创建为false）
  secret_enable = false
  #【自定义值】指定secret的内容
  secret_data = [
    { key = "dbHost", value = "MjAuNDYuMTIxLjExNA==" },
    { key = "dbPort", value = "MTU0MzI=" },
    { key = "dbUser", value = "ZG10Zw==" },
    { key = "dbPassword", value = "YUQzJCNHSGNSVk9yQ2Ux" },
    { key = "dbDatabase", value = "ZG10Z3Bn" }
  ]
  #【自定义值】指定secret的名称
  secret_name = "dmtg-server-db"
  #【自定义值】指定secret的标签
  secret_label = "postgres"
  #【自定义值】指定pod的环境变量（env_name为环境变量的名称，type为环境变量内的类型，secret_name为secret的名称，secret_key为需要获取的变量）
  #不需要env为下面这种写法
  #例：当env_type为valueFrom时,valueForm的type为secretKeyRef、filedRef时  不使用env是env =[]
  env = [
    { env_type = "valueForm", name = "POD_IP", valueForm_type = "fieldRef", field_path = "status.podIP" },
    { env_type = "valueForm", name = "SECRET_USER", valueForm_type = "secretKeyRef", secret_name = "my-secret", secret_key = "username" },
    { env_type = "valueForm", name = "CFG_MODE", valueForm_type = "configMapKeyRef", configmap_name = "my-config", configmap_key = "mode" }
  ]
  #例，可以写在一起，只能存在一个env
  #env = [
  #  { env_type = "env", name = "ENV_NORMAL", value = "abc" },
  #  { env_type = "valueForm", name = "POD_IP", valueForm_type = "fieldRef", field_path = "status.podIP" },
  #  { env_type = "valueForm", name = "SECRET_USER", valueForm_type = "secretKeyRef", secret_name = "my-secret", secret_key = "username" },
  #  { env_type = "valueForm", name = "CFG_MODE", valueForm_type = "configMapKeyRef", configmap_name = "my-config", configmap_key = "mode" }
  #]
  #【自定义值】指定env的来源
  #例：不需要env_form时
  env_from = []
  #例：只能存在一个env_from
  #env_from = [
  #  { type = "configMapRef" , name = "abc" },
  #  { type = "secretRef" , name = "abc" }
  #]
  #【自定义值】指定是否创建HPA
  hpa_enalbe                              = false
  #【自定义值】指定是否创建HPA资源的名称，不指定则默认跟服务同名
  hpa_name                                = ""
  #【自定义值】指定HPA监听的服务的类型（Deployment、StatefulSet）
  hpa_kind                                = "Deployment"
  #【自定义值】指定缩小的最小副本数
  minReplicas                             = 1
  #【自定义值】指定扩容的最大副本数
  maxReplicas                             = 5
  #【自定义值】指定扩缩容触发的条件
  metrics                                 = []
  #metrics                                 = [
  #  { type = "Resource", name = "cpu", target_type = "Utilization", averageUtilization = "50" },
  #  { type = "Resource", name = "memory", target_type = "Utilization", averageUtilization = "50" }
  #]
  #【自定义值】指定扩缩容触发的策略（目前个别集群暂不支持）
  behavior                                = []
  #behavior                                = [
  #  {
  #    scaleUp                             = [
  #      {
  #        stabilizationWindowSeconds      = "",
  #        selectPolicy                    = "Max",
  #        policies                        = [
  #          { type = "Percent", value = 50, periodSeconds = 60 }
  #        ]
  #      }
  #    ],
  #    scaleDown                           = [
  #      {
  #        stabilizationWindowSeconds      = "",
  #        selectPolicy                    = "Max",
  #        policies                        = [
  #          { type = "Percent", value = 50, periodSeconds = 60 }
  #        ]
  #      }
  #    ]
  #  }
  #]
}

########################## 4.1.1 ---------> VPC ########################################################################
module "aliyun-vpc" {
  #【固定值】指定组件入口位置
  source         = "./modules/aliyun/vpc/"
  #【固定值】指定中文名称
  zh_name        = "vpc"
  #【固定值】指定module类型
  module_type    = "microservice"
  #【固定值】指定层级
  index          = "3"
  #【固定值】指定引用目标
  parent         = "-"
  #【固定值】指定aliyun连接地址
  alibabacloudstack         = {
    access_key              = var.access_key
    secret_key              = var.secret_key
    region                  = var.region
    insecure                = var.insecure
    resource_group_set_name = var.resource_group_set_name
    domain                  = var.domain
    protocol                = var.protocol
  }
  #【自定义值】指定vpc名称
  vpc_name       = "测试VPC"
  #【自定义值】指定交换机名称
  vsw_name       = "测试vsw"
  #【自定义值】指定vpc地址段
  cidr_block     = "1.2.3.4/24"
  #【自定义值】指定交换机的可用区
  availability_zone = "1111"
}

########################## 4.1.2 ---------> SLB ########################################################################
module "aliyun-slb" {
  #【固定值】指定组件入口位置
  source         = "./modules/aliyun/slb/"
  #【固定值】指定中文名称
  zh_name        = "slb"
  #【固定值】指定module类型
  module_type    = "network"
  #【固定值】指定层级
  index          = "3"
  #【固定值】指定引用目标
  parent         = "-"
  #【固定值】指定aliyun连接地址
  alibabacloudstack         = {
    access_key              = var.access_key
    secret_key              = var.secret_key
    region                  = var.region
    insecure                = var.insecure
    resource_group_set_name = var.resource_group_set_name
    domain                  = var.domain
    protocol                = var.protocol
  }
  #【自定义值】指定slb所在的vpc名称
  vpc_name                  = "abcvpc"
  #【自定义值】指定slb名称
  slb_name                  = "slbabc"
  #【自定义值】指定slb规格
  specification             = "slb.s2.small"
}

########################## 4.1.3 ---------> Redis ########################################################################
module "aliyun-redis" {
  #【固定值】指定组件入口位置
  source                    = "./modules/aliyun/redis/"
  #【固定值】指定中文名称
  zh_name                   = "阿里云redis数据库"
  #【固定值】指定module类型
  module_type               = "middleware"
  #【固定值】指定层级
  index                     = "3"
  #【固定值】指定引用目标
  parent                    = "-"
  #【固定值】指定aliyun连接地址
  alibabacloudstack         = {
    access_key              = var.access_key
    secret_key              = var.secret_key
    region                  = var.region
    insecure                = var.insecure
    resource_group_set_name = var.resource_group_set_name
    domain                  = var.domain
    protocol                = var.protocol
  }
  #【自定义值】指定redis所在的vpc下的交换机id
  vswitch_id                = "vsw-abc123456489"
  #【自定义值】指定redis安全组的实例 IP 白名单
  security_ips              = ["10.0.0.1"]
  #【自定义值】指定redis名称
  instance_name             = "i60002.0测试REDIS"
  #【自定义值】指定redis版本(2.8、4.0、5.0、6.0、7.0)
  engine_version            = "4.0"
  #【自定义值】指定redis规格
  instance_class            = "redis.logic.sharding.2g.8db.0rodb.8proxy.default"
  #【自定义值】指定redis要使用的引擎(Redis、Memcache、Redis)
  instance_type             = "Redis"
  #【自定义值】指定redis要使用的cpu类型(目前只有intel)
  cpu_type                  = "intel"
  #【自定义值】指定redis密码(密码长度为 8 到 30 个字符，必须包含大写字母、小写字母和数字)
  password                  = "c25jiClv"
  #【自定义值】指定redis备份周期（有效值：["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]）
  backup_period             = ["Wednesday"]
  #【自定义值】指定redis备份时间（格式为HH:mmZ-HH:mmZ）
  backup_time               = "02:00Z-03:00Z"
}

########################## 4.1.4 ---------> RocketMQ ########################################################################
module "aliyun-rocketmq" {
  #【固定值】指定组件入口位置
  source                       = "./modules/aliyun/rocketmq"
  #【固定值】指定中文名称
  zh_name                      = "阿里云消息队列 - RocketMQ"
  #【固定值】指定module类型
  module_type                  = "middleware"
  #【固定值】指定层级
  index                        = "3"
  #【固定值】指定引用目标
  parent                       = "-"
  #【固定值】指定aliyun连接地址
  alibabacloudstack         = {
    access_key              = var.access_key
    secret_key              = var.secret_key
    region                  = var.region
    insecure                = var.insecure
    resource_group_set_name = var.resource_group_set_name
    domain                  = var.domain
    protocol                = var.protocol
  }
  #【自定义值】指定rocketmq的名称
  rocketmq_name                = "abcRocketMQ"
  #【自定义值】指定rocketmq的消息订阅TPS
  tps_receive_max              = 500
  #【自定义值】指定rocketmq的消息发送TPS
  tps_send_max                 = 500
  #【自定义值】指定rocketmq的Topic数上限
  topic_capacity               = 50
  #【固定值】指定rocketmq的集群
  cluster                      = "cluster1"
  #【自定义值】指定rocketmq是否独立名称
  independent_naming           = true
  #【自定义值】指定rocketmq的简要描述
  remark                      = "abc测试RocketMQ"
}

########################## 4.1.5 ---------> RDS ########################################################################
module "aliyun-rds" {
  #【固定值】指定组件入口位置
  source                    = "./modules/aliyun/rds/"
  #【固定值】指定中文名称
  zh_name                   = "阿里云RDS数据库"
  #【固定值】指定module类型
  module_type               = "db"
  #【固定值】指定层级
  index                     = "3"
  #【固定值】指定引用目标
  parent                    = "-"
  #【固定值】指定aliyun连接地址
  alibabacloudstack         = {
    access_key              = var.access_key
    secret_key              = var.secret_key
    region                  = var.region
    insecure                = var.insecure
    resource_group_set_name = var.resource_group_set_name
    domain                  = var.domain
    protocol                = var.protocol
  }
  #【固定值】指定rds固定信息
  rds                       = {
    creation                = "Rds"
    engine                  = "MySQL"
    storage_type            = "local_ssd"
  }
  #【自定义值】指定rds所在的vpc下的交换机id
  vswitch_id                = "vsw-abc123456489"
  #【自定义值】指定rds实例的规格（rds.mysql.t1.small、）
  instance_type             = "mysql.x4.4xlarge.2"
  #【自定义值】指定rds实例的版本
  engine_version            = "5.7"
  #【自定义值】指定rds实例的存储空间
  instance_storage          = "1000"
  #【自定义值】指定rds实例的名称
  instance_name             = "abc数据库"
  #【自定义值】指定rds实例的数据库名称,base_name为库名,character_set为编码规则
  rds_base                  = [
    { base_name = "abc", character_set = "utf8mb4"}
  ]
  #【自定义值】指定rds实例的数据库账户
  user                      = "abc"
  #【自定义值】指定rds实例的数据库密码
  password                  = "B3asdas2"
  #【自定义值】指定rds实例的数据库账户特权类型（Super：高权限、Normal:公共权限）
  account_type              = "Super"
  #【自定义值】指定rds实例的备份周期（有效值：["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]）
  preferred_backup_period   = ["Wednesday", "Friday"]
  #【自定义值】指定rds实例的备份时间（格式为HH:mmZ-HH:mmZ,默认为"02:00Z-03:00Z"）
  preferred_backup_time     = "02:00Z-03:00Z"
  #【自定义值】指定rds实例的数据备份保留天数（取值范围："7-730",本地磁盘无限）
  backup_retention_period   = 7
  #【自定义值】指定rds实例的日志备份（是否开启日志备份,默认开启）
  enable_backup_log         = true
  #【自定义值】指定rds实例的日志备份保留天数（取值范围："7-730",不能大于数据备份保留天数）
  log_backup_retention_period = 7
}

########################## 4.1.6 ---------> Mongodb ########################################################################
module "aliyun-mongodb" {
  #【固定值】指定组件入口位置
  source                       = "./modules/aliyun/mongodb"
  #【固定值】指定中文名称
  zh_name                      = "阿里云mongodb数据库 - Mongodb"
  #【固定值】指定module类型
  module_type                  = ""
  #【固定值】指定层级
  index                        = "3"
  #【固定值】指定引用目标
  parent                       = "-"
  #【固定值】指定aliyun连接地址
  alibabacloudstack         = {
    access_key              = var.access_key
    secret_key              = var.secret_key
    region                  = var.region
    insecure                = var.insecure
    resource_group_set_name = var.resource_group_set_name
    domain                  = var.domain
    protocol                = var.protocol
  }
  #【自定义值】指定MongoDB引擎的版本(3.4、4.0)
  engine_version              = "4.0"
  #【自定义值】指定MongoDB数据库实例的规格类型,例如：dds.mongo.s.smalldds.mongo.mid
  db_instance_class            = "dds.mongo.4xlarge"
  #【自定义值】指定MongoDB数据库实例的存储空间(单位:GB)
  db_instance_storage          = "1000"
  #【自定义值】指定MongoDB设置备份周期，指定每周的备份日["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  backup_period                = ["Wednesday"]
  #【自定义值】指定MongoDB设置陪时间，指定每天的备份时间范围(HH:mmZ-HH:mmZ 23:00Z-24:00Z)
  preferred_backup_time        = "20:00Z-21:00Z"
  #【自定义值】指定MongoDB设置MongoDB实例的名称
  name                         = "abc数据库"
  #【自定义值】指定MongoDB设置安全ip列表 ，允许这些ip地址访问MongoDB实例
  security_ip_list             = ["10.134.200.98", "10.134.200.71"]
  #【自定义值】指定MongoDB设置ssl加密(Open、Close、Update)
  ssl_action                   = "Open"
  #【自定义值】指定MongoDB设置透明数据加密(TDE)(Enabled、Disabled)
  tde_status                   = "Enabled"
  #【自定义值】指定MongoDB副本集节点数(1、3、5、7)
  replication_factor           = "3"
  #【自定义值】指定MongoDB的存储引擎(WiredTiger、RocksDB)
  storage_engine               = "WiredTiger"
  #【自定义值】指定MongoDB的root账户的密码
  account_password             = "abcdefg"
  #【自定义值】指定MongoDB的ECS安全组 ID。一个实例最多可以绑定 10 个 ECS 安全组
  security_group_id            = "sg-abc123"
}

########################## 4.1.7 ---------> CR ########################################################################
module "aliyun-cr" {
  #【固定值】指定组件入口位置
  source                       = "./modules/aliyun/cr/"
  #【固定值】指定中文名称
  zh_name                      = "容器镜像服务 - CR"
  #【固定值】指定module类型
  module_type                  = ""
  #【固定值】指定层级
  index                        = "3"
  #【固定值】指定引用目标
  parent                       = "-"
  #【固定值】指定aliyun连接地址
  alibabacloudstack         = {
    access_key              = var.access_key
    secret_key              = var.secret_key
    region                  = var.region
    insecure                = var.insecure
    resource_group_set_name = var.resource_group_set_name
    domain                  = var.domain
    protocol                = var.protocol
  }
  #【自定义值】指定容器镜像服务的命名空间
  cr_namespace                = "iac-test-namespace"
  #【自定义值】指定容器镜像服务是否自动创建镜像仓库
  auto_create                 = false
  #【自定义值】指定容器镜像服务的默认仓库类型（PUBLIC、PRIVATE）
  default_visibility          = "PUBLIC"
  #【自定义值】指定容器镜像服务的仓库
  cr_repo = [
    {name = "repo1", summary = "iac测试使用具体信息", repo_type = "PRIVATE", detail = "iac测试使用摘要"},
    {name = "repo2", summary = "iac测试使用具体信息", repo_type = "PRIVATE", detail = "iac测试使用摘要"}
  ]
}

########################## 4.1.8 ---------> ECS ########################################################################
module "aliyun-ecs" {
  #【固定值】指定组件入口位置
  source                       = "./modules/aliyun/ecs"
  #【固定值】指定中文名称
  zh_name                      = "阿里云容器服务 - ecs"
  #【固定值】指定module类型
  module_type                  = "calculate"
  #【固定值】指定层级
  index                        = "3"
  #【固定值】指定引用目标
  parent                       = "-"
  #【固定值】指定aliyun连接地址
  alibabacloudstack         = {
    access_key              = var.access_key
    secret_key              = var.secret_key
    region                  = var.region
    insecure                = var.insecure
    resource_group_set_name = var.resource_group_set_name
    domain                  = var.domain
    protocol                = var.protocol
  }
  #【自定义值】指定ecs所在的vpc名称
  vpc_name                     = "abcVPC"
  #【自定义值】指定ecs所在的group
  group_id                     = "abcasdxzxcasd"
  #【自定义值】指定ecs实例的镜像
  image_id                     = "m-j6asd6ja9asd8"
  #【自定义值】指定ecs实例的类型
  instance_type                = "ecs.s6-k-c1m2.2xlarge"
  #【自定义值】指定ecs实例的系统盘类型
  system_disk_category         = "cloud_sperf"
  #【自定义值】指定ecs实例的系统盘大小（GB）
  system_disk_size             = 200
  #【自定义值】指定ecs实例的系统盘名称,不指定则随机创建名称
  system_disk_name             = "abc服务器"
  #【自定义值】指定ecs实例的数量
  instance_count               = 3
  #【自定义值】指定ecs实例的数据盘（name为数据盘的名称、size为数据盘的大小、category为数据盘的类型(cloud、cloud_efficiency、cloud_ssdephemeral_ssd、cloud_efficiency)、delete_with_instance为实例销毁时是否直接删除数据盘、encrypted数据盘是否加密）,不指定则不创建。
  data_disks                   = [
    { name = "abcdisk" , size = 100 , category = "cloud" , encrypted = false, delete_with_instance = true}
  ]
  #【自定义值】指定ecs实例的密码
  password                     = "cdassadXYhVs"
  #【自定义值】指定ecs实例的标签,不指定则不创建
  tag_name                     = ""
  #【自定义值】指定ecs实例的名称（可以包含 2 到 128 个字符的字符串,必须仅包含字母数字字符或连字符,例如 “-”、“.”、“_”,并且不能以连字符开头或结尾,也不能以 http:// 或 https:// 开头）,不指定随机创建名称。
  instance_name                = "abc-cs"
}

########################## 4.1.9 ---------> Kubernetes ########################################################################
module "aliyun-kubernetes" {
  #【固定值】指定组件入口位置
  source                       = "./modules/aliyun/kubernetes"
  #【固定值】指定中文名称
  zh_name                      = "阿里云容器服务 - Kubernetes"
  #【固定值】指定module类型
  module_type                  = "calculate"
  #【固定值】指定层级
  index                        = "3"
  #【固定值】指定引用目标
  parent                       = "-"
  #【固定值】指定aliyun连接地址
  alibabacloudstack            = {
    access_key              = var.access_key
    secret_key              = var.secret_key
    region                  = var.region
    insecure                = var.insecure
    resource_group_set_name = var.resource_group_set_name
    domain                  = var.domain
    protocol                = var.protocol
  }
  #【自定义值】指定kubernetes集群所在的vpc名称
  vpc_name                     = "abc测试VPC"
  #【自定义值】指定kubernetes集群名称
  name                         = "abcK8s集群"
  #【自定义值】指定kubernetes集群类型
  cluster_type                 = "Kubernetes"
  #【自定义值】指定kubernetes集群版本（1.28.9-aliyun.1、1.20.11-aliyun.1）
  versions                      = "1.20.11-aliyun.1"
  #【自定义值】指定kubernetes集群主节点数
  master_count                 = 3
  #【自定义值】指定kubernetes集群操作系统
  os_type                      = "linux"
  #【自定义值】指定kubernetes集群节点架构
  platform                     = "AliyunLinux"
  #【自定义值】指定kubernetes集群主节点磁盘类型
  master_disk_category         = "cloud_sperf"
  #【自定义值】指定kubernetes集群主节点磁盘大小（GB）
  master_disk_size             = 200
  #【自定义值】指定kubernetes集群工作节点磁盘类型
  worker_disk_category         = "cloud_sperf"
  #【自定义值】指定kubernetes集群工作节点磁盘大小（GB）
  worker_disk_size             = 200
  #【自定义值】指定kubernetes集群设置集群删除保护（防止通过控制台或 API 误删除释放节点）
  delete_protection            = false
  #【自定义值】指定kubernetes集群是否创建新的nat网关
  new_nat_gateway              = false
  #【自定义值】指定kubernetes集群是否创建负载均衡
  slb_internet_enabled         = false
  #【自定义值】指定kubernetes集群代理模式（iptables、ipvs）
  proxy_mode                   = "ipvs"
  #【自定义值】指定kubernetes集群主节点规格
  master_instance_types        = ["ecs.s6-k-c1m1.2xlarge","ecs.s6-k-c1m1.2xlarge","ecs.s6-k-c1m1.2xlarge"]
  #【自定义值】指定kubernetes集群工作节点规格
  worker_instance_types        = ["ecs.s6-k-c1m4.4xlarge"]
  #【自定义值】指定kubernetes集群工作节点数
  num_of_nodes                 = 10
  #【自定义值】指定kubernetes集群是否允许ssh登录节点
  enable_ssh                   = false
  #【自定义值】指定kubernetes集群节点密码
  password                     = "asdasdhVs"
  #【自定义值】指定kubernetes集群设置pod网络块（推荐使用10.0.0.0/8，172.16-31.0.0/12-16，192.168.0.0/16，创建成功后不能修改）
  pod_cidr                     = "172.20.0.0/16"
  #【自定义值】指定kubernetes集群设置service网络块（推荐使用10.0.0.0/16-24，172.16-31.0.0/16-24，192.168.0.0/16-24，创建成功后不能修改）
  service_cidr                 = "172.21.0.0/20"
  #【自定义值】指定kubernetes集群单工作节点运行的pod数量（24=256个、25=128个、26=64个，允许24-28，24表示2^(32-24)）
  node_cidr_mask               = "26"
  #【自定义值】指定kubernetes集群的容器运行时（1.28.9-aliyun.1时为containerd、1.20.11-aliyun.1时为docker）
  runtime_name                 = "docker"
  #【自定义值】指定kubernetes集群的容器运行时版本（containerd为1.6.28、docker为19.03.15）
  runtime_version              = "19.03.15"
  #【自定义值】指定kubernetes集群是否自动创建高级安全组
  is_enterprise_security_group = true
  #【平台配置值】指定kubernetes集群插件（有需增删，联系管理员，默认安装ingress、ingress dashboard、日志服务、node-problem-detector、prometheus）
  cluster_addons               = var.cluster_addons
}

########################## 4.2.1 ---------> EDAS_NAMESPACE ########################################################################
module "ali_edas_namespace" {
  #【固定值】指定组件入口位置
  source                       = "./modules/aliyun/edas_namespace"
  #【固定值】指定中文名称
  zh_name                      = "阿里云微服务空间 - EDAS_NAMESPACE"
  #【固定值】指定module类型
  module_type                  = "db"
  #【固定值】指定层级
  index                        = "3"
  #【固定值】指定引用目标
  parent                       = "-"
  #【固定值】指定aliyun连接地址
  alibabacloudstack            = {
    access_key                 = var.access_key
    secret_key                 = var.secret_key
    department                 = var.department
    resource_group             = var.resource_group
    region                     = var.region
    insecure                   = var.insecure
    resource_group_set_name    = var.resource_group_set_name
    domain                     = var.domain
    protocol                   = var.protocol
    is_center_region           = var.is_center_region
    endpoints_edas             = var.edas_domain
  }
  #【自定义值】指定edas微服务空间的区域
  region                       = "js-1"
  #【自定义值】指定edas微服务空间的名称
  namespace_name               = "testiac"
  #【自定义值】指定加入edas微服务空间的k8s集群id
  cs_cluster_id                = "cac2b3ea5a286499f95777734bd83d168"
}

########################## 4.2.2 ---------> EDAS_App ########################################################################
module "abc" {
  #【固定值】指定组件入口位置
  source                       = "./modules/aliyun/edas"
  #【固定值】指定中文名称
  zh_name                      = "服务"
  #【固定值】指定module类型
  module_type                  = "edas_app"
  #【固定值】指定层级
  index                        = "3"
  #【固定值】指定引用目标
  parent                       = "-"
  #【固定值】指定平台连接信息
  kubernetes              = {
    host                         =   var.kubernetes_host
    client_certificate           =   var.kubernetes_client_certificate
    client_key                   =   var.kubernetes_client_key
    cluster_ca_certificate       =   var.kubernetes_cluster_ca_certificate
  }
  #【固定值】指定aliyun连接地址
  alibabacloudstack            = {
    access_key                 = var.access_key
    secret_key                 = var.secret_key
    region                     = var.region
    insecure                   = var.insecure
    department                 = var.department
    resource_group             = var.resource_group
    resource_group_set_name    = var.resource_group_set_name
    domain                     = var.domain
    protocol                   = var.protocol
    is_center_region           = var.is_center_region
    endpoints_edas             = var.edas_domain
    endpoints_acm              = var.acm_domain
  }
  #【自定义值】指定发布的edas服务所在的微服务空间
  logical_region_id            = "js-1:abc"
  #【自定义值】指定edas服务的程序包类型
  package_type                 = "Image"
  #【自定义值】指定edas服务的名称
  application_name             = "abc"
  #【自定义值】指定edas服务的命名空间
  namespace                    = "abc"
  #【自定义值】指定edas服务的所需要导入的k8s集群id
  cluster_id                   = "sadasdasdasdasdasdadasd5"
  #【自定义值】指定edas服务的副本数
  replicas                     = 2
  #【自定义值】指定edas服务的镜像仓库类型，(类型在cr概览里的实例id处)，专有云高级版为cri-private，专有云标准版为cri
  cr_ee_repo_id                = "cri"
  #【自定义值】指定edas服务的镜像
  image_url                    = "sdasda/iasd/asdasdasda"
  #【自定义值】指定edas服务的公共网络 SLB ID，如果未配置，EDAS 将自动创建新的 SLB，不需要则保持为null
  internet_slb_id              = null
  #【自定义值】指定edas服务的公共网络 SLB 类型的外部流量策略（填写为Local、Cluster）
  internet_external_traffic_policy = null
  #【自定义值】指定edas服务的公共网络 SLB 调度算法(rr(轮询)、wrr(加权轮询))
  internet_scheduler           = null
  #【自定义值】指定edas服务的公共网络 SLB 监听形式，protocol为公网 SLB 协议类型支持TCP、HTTP、HTTPS，tatget_port为SLB 后端端口，也是应用程序的服务端口，范围从 1 到 65535，port公网 SLB 前端端口，范围 1~65535
  internet_service_port_infos  = []
  #【自定义值】指定edas服务的私有网络 SLB ID。如果未配置，EDAS 将自动创建新的 SLB，不需要则保持为null
  intranet_slb_id              = null
  #例：intranet_slb_id = "lb-abcdefghsj"
  #【自定义值】指定edas服务的私有网络 SLB 类型的外部流量策略（填写为Local、Cluster）
  intranet_external_traffic_policy = null
  #例：intranet_external_traffic_policy = "Local"
  #【自定义值】指定edas服务的私有网络 SLB 调度算法(rr(轮询)、wrr(加权轮询))
  intranet_scheduler           = null
  #例：intranet_scheduler = "rr"
  #【自定义值】指定edas服务的私有网络 SLB 监听形式，protocol为公网 SLB 协议类型支持TCP、HTTP、HTTPS，tatget_port为SLB 后端端口，也是应用程序的服务端口，范围从 1 到 65535，port公网 SLB 前端端口，范围 1~65535
  intranet_service_port_infos  = []
  #例：
  #intranet_service_port_infos = [
  #  { "protocol" = "TCP", "target_port" = 8080, "port" = 8080 }
  #]
  #【自定义值】指定edas服务的最大cpu资源
  limit_m_cpu                  = 2000
  #【自定义值】指定edas服务的最大内存资源
  limit_mem                    = 3000
  #【自定义值】指定edas服务的请求cpu资源
  requests_m_cpu               = 500
  #【自定义值】指定edas服务的请求内存资源
  requests_mem                 = 1024
  #【自定义值】指定edas服务的启动命令，只能写一种命令（"java","/bin/bash"）没有保持null
  command                      = null
  #【自定义值】指定edas服务的启动命令参数，可以写多个参数["",""]，没有保持null
  command_args                 = null
  #【自定义值】指定edas服务的环境变量，没有保持null
  envs = null
  #例：envs = {"ARGS_OPTS"="--spring.cloud.nacos.config.enabled=true","nginx_port"="80"}
  #【自定义值】指定edas服务停止前执行的命令，没有保持null
  pre_stop                     = null
  #【自定义值】指定edas服务启动后执行的命令，没有保持null
  post_start                   = null
  #【自定义值】指定edas服务的存活探针，没有保持null
  liveness                     = null
  #例：liveness = { "failureThreshold": 3,"initialDelaySeconds": 5,"successThreshold": 1,"timeoutSeconds": 1,"tcpSocket":{"host":"", "port":8080} }
  #【自定义值】指定edas服务的就绪探针，没有保持null
  readiness                    = null
  #【自定义值】指定edas服务挂载的nasid，没有保持null
  nas_id                       = null
  #【自定义值】指定edas服务的挂载配置，没有保持null
  mount_descs                  = null
  #例：
  #mount_descs = [
  #  {"nasPath": "/k8s","mountPath": "/mnt"},
  #  {"nasPath": "/files","mountPath": "/app/files"}
  #]
  #【自定义值】指定edas服务的挂载到主机的配置，没有保持[],node_path为主机上的路径，mount_path为容器中的路径，type为挂载的类型（默认类型为""，文件类型为file，目录为filepath）
  local_volume                 = []
  #例：
  #local_volume = [
  #  { node_path = "", mount_path = "", type = ""}
  #]
  #【自定义值】指定edas服务挂载configmap，没有保持[]，name为ConfigMap 或 Secret 的名称，type为ConfigMap 和 Secret，mount_path为挂载路径
  config_mount_descs           = []
  #例：
  #config_mount_descs = [
  #  { name = "", type = "", mount_path = ""}
  #]
  #【自定义值】指定edas服务挂载pvc，没有保持[]，pvc_name为PVC 卷的名称，mount_path为挂载路径,read_only为挂载模式true 表示只读，false 表示读写
  pvc_mount_descs              = []
  #例：
  #pvc_mount_descs = [
  #  { pvc_name = "", mount_paths = [
  #       { mount_path = "", read_only = "" }
  #     ]
  #   }
  #]
  #【自定义值】指定edas服务的host配置，ip为IP地址，hostnames为域名列表
  host_aliases = []
  #例：
  #host_aliases = [
  #  { ip = "", hostnames = [""] }
  #]
  #【自定义值】指定edas服务的调度容忍，key（必填）为节点标签的键，value（可选）为节点标签的值，operator（必填）为操作符号，取值：Equal、Exists，effect（必填）为效果，取值：NoExecute、NoSchedule、PreferNoSchedul、toleration_seconds（可选）为容忍时间（秒）
  #该参数不使用保持为空，可选的参数不需要填的话保持为null就代表不使用
  custom_tolerations = []
  #例：custom_tolerations = [
  #  { key = "test", value = "test", operator = "Equal", effect = "NoSchedule", toleration_seconds = "3" }
  #]
  #【自定义值】指定edas服务的必须满足的节点亲和性，key（必填）为节点标签的键，value（可选）为节点标签的值，operator（必填）为操作符号，取值：In、NotIn、Exists、DoesNotExist、Gt、Lt
  #该参数不使用保持为空，可选的参数不需要填的话保持为null就代表不使用
  custom_node_affinity_require = []
  #例：custom_node_affinity_require = [
  #  {
  #    match_expressions = [
  #      { key = "test", values = ["aaaaa", "bbbb"], operator = "In" }
  #    ]
  #  }
  #]
  #【自定义值】指定edas服务的尽量满足的节点亲和性，weight（可选）为权重，取值范围：1~100，key（必填）为节点标签的键，value（可选）为节点标签的值，operator（必填）为操作符号，取值：In、NotIn、Exists、DoesNotExist、Gt、Lt
  #该参数不使用保持为空，可选的参数不需要填的话保持为null就代表不使用
  custom_node_affinity_preferred = []
  #例：custom_node_affinity_preferred = [
  #  {
  #    weight = 100,
  #    match_expressions = [
  #      { key = "test", values = ["aaaaa", "bbbb"], operator = "In" }
  #    ]
  #  }
  #]
  #【自定义值】指定edas服务的必须满足的Pod亲和性，k8s_namespace（可选）为集群的命名空间，topology_key（必填）为拓扑域，key（必填）为节点标签的键，value（可选）为节点标签的值，operator（必填）为操作符号，取值：In、NotIn、Exists、DoesNotExist、Gt、Lt
  #该参数不使用保持为空，可选的参数不需要填的话保持为null就代表不使用
  custom_pod_affinity_require = []
  #例：custom_pod_affinity_require = [
  #  {
  #    k8s_namespace = ["default"],
  #    topology_key = "test",
  #    match_expressions = [
  #      { key = "test", values = ["aaaaa", "bbbb"], operator = "In" },
  #      { key = "test1", values = ["aaaaa2", "bbbb2"], operator = "In" }
  #    ]
  #  }
  #]
  #【自定义值】指定edas服务的尽量满足的Pod亲和性，weight（可选）为权重，取值范围：1~100，k8s_namespace（可选）为集群的命名空间，topology_key（必填）为拓扑域，key（必填）为节点标签的键，value（可选）为节点标签的值，operator（必填）为操作符号，取值：In、NotIn、Exists、DoesNotExist、Gt、Lt
  #该参数不使用保持为空，可选的参数不需要填的话保持为null就代表不使用
  custom_pod_affinity_preferred = []
  #例：custom_pod_affinity_preferred = [
  #  {
  #    weight = 1,
  #    k8s_namespace = ["default"],
  #    topology_key = "test2",
  #    match_expressions = [
  #      { key = "test1", values = ["aaaaa1", "bbbb1"], operator = "In" },
  #      { key = "test1", values = ["aaaaa2", "bbbb2"], operator = "NotIn" }
  #    ]
  #  }
  #]
  #【自定义值】指定edas服务的必须满足的Pod反亲和性，k8s_namespace（可选）为集群的命名空间，topology_key（必填）为拓扑域，key（必填）为节点标签的键，value（可选）为节点标签的值，operator（必填）为操作符号，取值：In、NotIn、Exists、DoesNotExist、Gt、Lt
  #该参数不使用保持为空，可选的参数不需要填的话保持为null就代表不使用
  custom_pod_ant_affinity_require = []
  #例：custom_pod_ant_affinity_require = [
  #  {
  #    k8s_namespace = ["default"],
  #    topology_key = "test3",
  #    match_expressions = [
  #      { key = "test3", values = ["aaaaa3", "bbbb3"], operator = "In" },
  #      { key = "test4", values = ["aaaaa4", "bbbb4"], operator = "NotIn" }
  #    ]
  #  }
  #]
  #【自定义值】指定edas服务的尽量满足的Pod反亲和性，weight（可选）为权重，取值范围：1~100，k8s_namespace（可选）为集群的命名空间，topology_key（必填）为拓扑域，key（必填）为节点标签的键，value（可选）为节点标签的值，operator（必填）为操作符号，取值：In、NotIn、Exists、DoesNotExist、Gt、Lt
  #该参数不使用保持为空，可选的参数不需要填的话保持为null就代表不使用
  custom_pod_ant_affinity_preferred = []
  #例：custom_pod_ant_affinity_preferred = [
  #  {
  #    weight = 1,
  #    k8s_namespace = ["default"],
  #    topology_key = "test5",
  #    match_expressions = [
  #      { key = "test5", values = ["aaaaa5", "bbbb5"], operator = "In" }
  #    ]
  #  }
  #]
  #【自定义值-必填】指定是否创建svc（创建为true，不创建为false）
  svc_enable                   = true
  #【自定义值-必填】指定svc的名称
  svc_name                     = "adsda"
  #【自定义值】指定svc类型（填写NodePort、ClusterIP）
  svcType                      = "ClusterIP"
  #【自定义值】指定svc（svcPort为svc端口，svcTargetPort为目标端口，nodePort存在则填写不存在则填写为"",需要随机创建nodePort端口填写为0,nodePort只有当svc类型为NodePort和LoadBalance时生效）
  svc  = [
    { name = "http", svcPort = "80",svcTargetPort= "80"}
  ]
  #【自定义值】指定svc的ip地址（没有时，指定为null）
  svc_clusterip                = null
  #【自定义值】指定是否添加配置
  acm_enable                   = false
  #【自定义值】指定导入的配置信息，type为配置类型（text、json、xml、yaml、html、properties），tags为配置标签，namespace_id为微服务空间id，desc为配置描述信息，data_id为配置的data_id，group为配置的group，content为导入的配置文件名称，可以导入多个配置文件acm_info中一条为一个配置文件信息，不需要的填null
  acm_info                        = []
  #acm_info                      = [
  #  { type = "text", tags = "aaaa,bbbb", namespace_id = "asdadadad", desc = "test1", data_id = "test1", app_name = "abc", content = "abc.txt", group = "DEFAULT_GROUP" },
  #  { type = "text", tags = null, namespace_id = "asdadadad", desc = null, data_id = "test1", app_name = null, content = "def.txt", group = "DEFAULT_GROUP" }
  #]
}

########################## 5.1.1 ---------> 虚机服务 ############################################################################
module "abc" {
  #【固定值】指定组件入口位置
  source      = "./modules/vm_app/"
  #【固定值】指定中文名称
  zh_name     = "vm_app服务"
  #【固定值】指定module类型
  module_type = "microservice"
  #【固定值】指定层级
  index       = "3"
  #【固定值】指定引用目标
  parent      = "-"
  ssh = {
    type      = var.ssh_type
    user      = var.ssh_user
    password  = var.ssh_password
    host      = var.ssh_ip
    insecure  = var.ssh_insecure
    port      = var.ssh_port
  }
  #【自定义值-必填】指定是否需要更新或执行这个服务的操作
  apply_enable = true
  #【自定义值-必填】指定需要部署的宿主机地址、端口
  instance    = [
    { ip = "1.2.3.4", port = "22" , user = "abc" , password = "abc"}
  ]
  #【自定义值-必填】指定需要部署的宿主机用户（exec_user）、文件（exec_package）(只包括.jar、.war、.tar（docker镜像包）、.tar.gz、.zip、.tgz，其他类型都为文本文件类型)、文件路径（exec_dir）、执行命令（exec_command）
  exec        = [
    { exec_user = "abc", exec_package = "abc.war" ,exec_dir = "/ear/deploy", exec_command = ["/opt/sh_test/1.sh"] },
    { exec_user = "abc", exec_package = "abc.zip" ,exec_dir = "/ear/deploy", exec_command = ["/opt/sh_test/1.sh"] },
    { exec_user = "abc", exec_package = ["abc.tar.gz","abc.tar"] ,exec_dir = "/ear/deploy", exec_command = ["/opt/sh_test/1.sh","/optsh_test/2.sh"] }
  ]
}