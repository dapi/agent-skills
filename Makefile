all:
	npx skills add dapi/agent-skills --all -g
	npx skills add dapi/agent-skills --skill workspace-cli --agent '*' -g -y
