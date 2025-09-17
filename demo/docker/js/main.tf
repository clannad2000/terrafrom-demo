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
########################## 3.1.1 ---------> pod ########################################################################
module "k8s-zygk-ui" { #【固定值】 指定module名称
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
  replicas                = 1
  #【自定义值-需确认】指定容器的端口
  containerPort           = [
    {name = "http",port="18080"}
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
    { name = "http",svcPort = "18080",svcTargetPort= "18080",nodePort = 32025 }
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
  #例：
  #ingress_tls = [
  #  { tls_hosts = ["abc.com.cn"], tls_secret_name = "abc.com.cn" }
  #]
  #【自定义值】指定是否创建configmap（创建为true，不创建为false，默认创建的configmap的名字和服务的pod名一致）
  configmap_enable        = false
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
  env = []
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