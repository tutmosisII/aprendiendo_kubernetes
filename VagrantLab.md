# Vagrant Lab

Para ejecutar este laboratorio usted debe tener instalado en su computador Virtualbox y Vagrant.

## 1) Clone o descague este repositorio

   **git clone** https://github.com/tutmosisII/aprendiendo_kubernetes.git

   **Descarga: **
   https://github.com/tutmosisII/aprendiendo_kubernetes/archive/master.zip

---

## 2) Inicie nodo master

Vaya hasta la carpeta vagrant_machine/master y ejecute el siguiente comando.

    vagrant up

Se produce una salida similar a esta:

    masterk: [bootstraptoken] using token: b914c3.jod8471z6vuwwzcx
    masterk: [bootstraptoken] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
    masterk: [bootstraptoken] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
    masterk: [bootstraptoken] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
    masterk: [bootstraptoken] creating the "cluster-info" ConfigMap in the "kube-public" namespace
    masterk: [addons] Applied essential addon: CoreDNS
    masterk: [addons] Applied essential addon: kube-proxy
    masterk:
    masterk: Your Kubernetes master has initialized successfully!

En este punto usted ha inicializado un nodo master de kubelet usando la red de calico.

Usted puede verificar el estado del master creado usando los siguientes comandos:

    vagrant ssh
    kubectl get nodes

Una vez listados los nodos tome el id del master y úselo para leer la descripción.

    kubectl describe node <id_node>

Pude verificar También que los pods de [calico](https://www.projectcalico.org/) están corriendo
