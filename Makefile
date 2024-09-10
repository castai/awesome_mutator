build:
	 bash scripts/build_multi.sh 

install: 
	helm upgrade -i -n castai-agent awesome-mutator charts/awesome-mutator

uninstall:
	helm uninstall -n castai-agent awesome-mutator

publish-chart:
	bash scripts/helm-chart-publish.sh