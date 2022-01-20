#? Argo Workflows - K8s

# Vars
REPO := $(shell git rev-parse --show-toplevel)



#? Create a cluster with k3d
.PHONY: apply
apply:
	. ./k3d_argocd_cluster.sh && create_cluster && install_argocd && access_argocd


#? Destroy the cluster 
.PHONY: destroy
destroy:
	. ./k3d_argocd_cluster.sh && delete_cluster






# # #* Create k8s directory structure  ==> make create_dir
.PHONY: create_dir
create_dir:
	@ls "k8s/apps/" >/dev/null && echo "==> k8s/apps/ directories ✓" || mkdir -p k8s/apps/ 

	@[ -f ".gitattributes" ] && echo "==> .gitattributes ✓" || echo "* text eol=lf" > .gitattributes;

	@[ -f "readme.md" ] && echo "==> readme.md ✓" || curl https://gist.githubusercontent.com/J0hn-B/0a8bc6d764576c1ebdcc3ecb21c3ec33/raw > readme.md;

	@[ -f "k3d_argocd_cluster.sh" ] && echo "==> k3d_argo_cluster.sh ✓" || curl https://gist.githubusercontent.com/J0hn-B/7dad3e4d630ec7e61e36f07d7da55fd7/raw > k3d_argocd_cluster.sh;

	@[ -f ".gitignore" ] && echo "==> .gitignore ✓" || curl https://raw.githubusercontent.com/kubernetes/kubernetes/master/.gitignore > .gitignore;


# # #* Lint code  ==> make code_lint
.PHONY: code_lint
code_lint:
	@echo "$(GREEN) ==> Github Super-Linter will validate your source code.$(NC) < https://github.com/github/super-linter >"
	docker run --rm -e KUBERNETES_KUBEVAL_OPTIONS=--ignore-missing-schemas -e RUN_LOCAL=true \
	-v $(REPO):/tmp/lint ghcr.io/github/super-linter:slim-v4
	
ifeq ($(shell uname), Linux)
	find $(REPO) -type f -name "super-linter.log" -exec rm -f {} \;
else  
	powershell "Get-ChildItem -Recurse $(REPO) | where Name -match 'super-linter.log' | Remove-Item"
endif


# # #* Run automatic checks for rule violations, against Kubernetes manifests YAML files  ==> make datree
.PHONY: datree
datree:
	@for file in k8s/apps/*/*/*.yaml; do \
        echo $$file; cat $$file | docker run -i datree/datree test - --ignore-missing-schemas;  \
    done





