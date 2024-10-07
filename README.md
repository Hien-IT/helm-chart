//test chart
helm template --debug ./ehiring > output/ehiring.yaml

//----------------------------------//
cd ehiring-openshift
helm template --release-name ehiring . > ../output/ehiring.yaml
