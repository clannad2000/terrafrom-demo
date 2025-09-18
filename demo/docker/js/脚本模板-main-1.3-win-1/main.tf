########################## 3.1.1 ---------> zygk-ui pod ########################################################################
module "zygk-ui" { #【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source                  = "./modules/k8s/pod/"
  #【自定义值】指定中文名称
  zh_name                 = "动态作业管控前端微服务"
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
  replicas                = 2
  #【自定义值-需确认】指定容器的端口
  containerPort           = [
    {name = "port",port="18080"}
  ]
  #【自定义值-需确认】指定pod最大的cpu资源
  limitsCpu               = "250m"
  #【自定义值-需确认】指定pod最大的内存资源
  limitsMemory            = "1000Mi"
  #【自定义值-需确认】指定pod默认请求的cpu资源
  requestsCpu             = "250m"
  #【自定义值-需确认】指定pod默认请求的x内存资源
  requestsMemory          = "1000Mi"
  #【自定义值】指定是否添加svc（创建为true，不创建为false 默认创建的svc的名字和服务的pod名一致）
  svc_enable              = true
  #【自定义值】指定svc类型（填写NodePort或ClusterIP，不创建则不填或保持默认）
  svcType                 = "NodePort"
  #【自定义值-需确认】指定pod的svc（svcPort为svc端口，svcTargetPort为目标端口，nodePort存在则填写不存在则nodePort = "",随机生成nodePort则填0）
  svc  = [
    { name = "port",svcPort = "18080",svcTargetPort= "18080",nodePort = "32025" }
  ]
  #【自定义值-需确认】指定svc的ip地址
  svc_clusterip           = ""
  #【自定义值-需确认】指定pod的host配置(如果没有则填'[]')
  hostAliases             = []
  #【自定义值】指定pod的元数据名称
  metadataName            = "zygk-ui"
  #【自定义值】指定pod的镜像名称
  containerImage          = "hub.js.sgcc.com.cn/shebeiyu/zygk-ui:1.1.1"
  #【自定义值】指定pod的命令
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
  livenessProbe_port                     = 6443
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
  readinessProbe_port      = 6443
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
  volumeMounts = []
  volumes = []
  #【自定义值】指定是否添加ingress（创建为true，不创建为false，默认创建的ingress的名字和服务的pod名一致）
  ingress_enable          = false
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
  paths                   = []
  #【自定义值】指定ingress的tls协议
  ingress_tls = []
  #【自定义值】指定是否创建configmap（创建为true，不创建为false，默认创建的configmap的名字和服务的pod名一致）
  configmap_enable        = false
  config_file = []
  config_data = []
  #【自定义值】指定是否创建secret（创建为true，不创建为false）
  secret_enable = false
  #【自定义值】指定secret的内容
  secret_data = []
  #【自定义值】指定secret的名称
  secret_name = "dmtg-server-db"
  #【自定义值】指定secret的标签
  secret_label = "postgres"
  #【自定义值】指定env的类型（类型为env、valueFrom）
  #【自定义值】指定pod的环境变量（env_name为环境变量的名称，type为环境变量内的类型，secret_name为secret的名称，secret_key为需要获取的变量）
  #当env_type为env时
  env = []
  #【自定义值】指定env的来源
  env_from = []
  #对其他module提供可用引用为如下
  #  host (k8s中svc名称)
  #  port (k8s中svc端口)  port (k8s中svc端口)
}


########################## 3.1.1 ---------> zygk-ui pod ########################################################################
module "zygk-basic-management" { #【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source                  = "./modules/k8s/pod/"
  #【自定义值】指定中文名称
  zh_name                 = "动态作业管控后端微服务"
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
  replicas                = 2
  #【自定义值-需确认】指定容器的端口
  containerPort           = [
    {name = "port",port="19510"}
  ]
  #【自定义值-需确认】指定pod最大的cpu资源
  limitsCpu               = "250m"
  #【自定义值-需确认】指定pod最大的内存资源
  limitsMemory            = "1000Mi"
  #【自定义值-需确认】指定pod默认请求的cpu资源
  requestsCpu             = "500m"
  #【自定义值-需确认】指定pod默认请求的x内存资源
  requestsMemory          = "2000Mi"
  #【自定义值】指定是否添加svc（创建为true，不创建为false 默认创建的svc的名字和服务的pod名一致）
  svc_enable              = true
  #【自定义值】指定svc类型（填写NodePort或ClusterIP，不创建则不填或保持默认）
  svcType                 = "ClusterIP"
  #【自定义值-需确认】指定pod的svc（svcPort为svc端口，svcTargetPort为目标端口，nodePort存在则填写不存在则nodePort = "",随机生成nodePort则填0）
  svc  = [
    { name = "port",svcPort = "19510",svcTargetPort= "19510",nodePort = "" }
  ]
  #【自定义值-需确认】指定svc的ip地址
  svc_clusterip           = ""
  #【自定义值-需确认】指定pod的host配置(如果没有则填'[]')
  hostAliases             = []
  #【自定义值】指定pod的元数据名称
  metadataName            = "zygk-basic-management"
  #【自定义值】指定pod的镜像名称
  containerImage          = "hub.js.sgcc.com.cn/shebeiyu/zygk-basic-management:1.1.1"
  #【自定义值】指定pod的命令
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
  livenessProbe_port                     = 6443
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
  readinessProbe_port      = 6443
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
  volumeMounts = []
  volumes = []
  #【自定义值】指定是否添加ingress（创建为true，不创建为false，默认创建的ingress的名字和服务的pod名一致）
  ingress_enable          = false
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
  paths                   = []
  #【自定义值】指定ingress的tls协议
  ingress_tls = []

  #【自定义值】指定是否创建configmap（创建为true，不创建为false，默认创建的configmap的名字和服务的pod名一致）
  configmap_enable        = false
  config_file = []
  config_data = []
  #【自定义值】指定是否创建secret（创建为true，不创建为false）
  secret_enable = false
  #【自定义值】指定secret的内容
  secret_data = []
  #【自定义值】指定secret的名称
  secret_name = "dmtg-server-db"
  #【自定义值】指定secret的标签
  secret_label = "postgres"
  #【自定义值】指定env的类型（类型为env、valueFrom）
  #【自定义值】指定pod的环境变量（env_name为环境变量的名称，type为环境变量内的类型，secret_name为secret的名称，secret_key为需要获取的变量）
  #当env_type为env时
  env = []
  #【自定义值】指定env的来源
  env_from = []
  #对其他module提供可用引用为如下
  #  host (k8s中svc名称)
  #  port (k8s中svc端口)  port (k8s中svc端口)
}


########################## 3.1.1 ---------> zygk-ui pod ########################################################################
module "zygk-external-system" { #【固定值】 指定module名称
  #【固定值】指定组件入口位置
  source                  = "./modules/k8s/pod/"
  #【自定义值】指定中文名称
  zh_name                 = "外部系统对接微服务"
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
  replicas                = 2
  #【自定义值-需确认】指定容器的端口
  containerPort           = [
    {name = "port",port="19530"}
  ]
  #【自定义值-需确认】指定pod最大的cpu资源
  limitsCpu               = "250m"
  #【自定义值-需确认】指定pod最大的内存资源
  limitsMemory            = "1000Mi"
  #【自定义值-需确认】指定pod默认请求的cpu资源
  requestsCpu             = "500m"
  #【自定义值-需确认】指定pod默认请求的x内存资源
  requestsMemory          = "2000Mi"
  #【自定义值】指定是否添加svc（创建为true，不创建为false 默认创建的svc的名字和服务的pod名一致）
  svc_enable              = true
  #【自定义值】指定svc类型（填写NodePort或ClusterIP，不创建则不填或保持默认）
  svcType                 = "ClusterIP"
  #【自定义值-需确认】指定pod的svc（svcPort为svc端口，svcTargetPort为目标端口，nodePort存在则填写不存在则nodePort = "",随机生成nodePort则填0）
  svc  = [
    { name = "port",svcPort = "19530",svcTargetPort= "19530",nodePort = "" }
  ]
  #【自定义值-需确认】指定svc的ip地址
  svc_clusterip           = ""
  #【自定义值-需确认】指定pod的host配置(如果没有则填'[]')
  hostAliases             = []
  #【自定义值】指定pod的元数据名称
  metadataName            = "zygk-external-system"
  #【自定义值】指定pod的镜像名称
  containerImage          = "hub.js.sgcc.com.cn/shebeiyu/zygk-external-system:1.1.1"
  #【自定义值】指定pod的命令
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
  livenessProbe_port                     = 6443
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
  readinessProbe_port      = 6443
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
  volumeMounts = []
  volumes = []
  #【自定义值】指定是否添加ingress（创建为true，不创建为false，默认创建的ingress的名字和服务的pod名一致）
  ingress_enable          = false
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
  paths                   = []
  #【自定义值】指定ingress的tls协议
  ingress_tls = []

  #【自定义值】指定是否创建configmap（创建为true，不创建为false，默认创建的configmap的名字和服务的pod名一致）
  configmap_enable        = false
  config_file = []
  config_data = []
  #【自定义值】指定是否创建secret（创建为true，不创建为false）
  secret_enable = false
  #【自定义值】指定secret的内容
  secret_data = []
  #【自定义值】指定secret的名称
  secret_name = "dmtg-server-db"
  #【自定义值】指定secret的标签
  secret_label = "postgres"
  #【自定义值】指定env的类型（类型为env、valueFrom）
  #【自定义值】指定pod的环境变量（env_name为环境变量的名称，type为环境变量内的类型，secret_name为secret的名称，secret_key为需要获取的变量）
  #当env_type为env时
  env = []
  #【自定义值】指定env的来源
  env_from = []
  #对其他module提供可用引用为如下
  #  host (k8s中svc名称)
  #  port (k8s中svc端口)  port (k8s中svc端口)
}