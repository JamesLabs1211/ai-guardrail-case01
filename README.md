# F5 AI Guardrail Quick Demo Application
- This repository provides a lightweight AI test lab, intentionally built without an AI backend application or orchestration component.
- The purpose of this environment is to enable quick demo testing of F5 AI Guardrail using a CPU-only Small Language Model (SLM).
- In this setup, BIG-IP is used to strictly limit the model’s generated responses, keeping them short and concise to ensure fast response times.
- Although response length can be controlled by an LLM orchestration application, leveraging BIG-IP in this scenario provides added flexibility and enables additional use cases in future architectures.

## 1. Prepare the Environment Script
- Update the env.example file with your own values (provider name, API token, Calypso URL, and project ID).
- Refer to the configuration guide for instructions on how to obtain the required values from the F5 AI Guardrail portal.
```
# Frontend -> Proxy
GUARDRAIL_GW_BASE_URL="http://127.0.0.1:18080"
DEFAULT_PROVIDER="<<YOUR PROVIDER NAME in F5 AI Guardrail Portal>>"

# Proxy -> Calypso / F5 AI Guardrail
CALYPSOAI_TOKEN="<your-ai-guardrail-api-token>"
CALYPSOAI_URL="<your-ai-guardrail-url>"
CALYPSOAI_PROJECT_ID="<your-guardrail-project-id>"
```
## 2. Proceed the Installation
```
sudo mkdir -p /opt/chatapp
sudo chown -R $USER:$USER /opt/chatapp
cd /opt/chatapp

git clone https://github.com/JamesLabs1211/ai-guardrail-case01.git .
chmod +x install.sh run.sh

./install.sh
nano .env
./run.sh
```

