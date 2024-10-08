//test chart
helm template --debug ./ehiring > output/ehiring.yaml

//----------------------------------//

// gen chart to file
cd ehiring-openshift/ehiring-k8s
helm template --debug --release-name ehiring . > ../output/ehiring.yaml
