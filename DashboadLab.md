# Desplegando El Dashboard de kubernetes

1) Instale el dashboard en el Cluster

2) cree el rol de administrador

3) Obtenga el token del administrador

4) Levante el kube proxy
5) Ingrese a la url en localhost:8081
6) Seleccione la opcion de ingresar con el token

# Instalación del servicio de metricas para el dashboard.

1) clone el repositorio
git clone https://github.com/kubernetes-incubator/metrics-server
2) Ingrese al directorio Desplieguelo usando.
cd metrics-server
kubectl apply --filename deploy/1.8+/
