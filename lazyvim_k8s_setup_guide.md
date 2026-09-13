# Kubernetes YAML LSP Setup in LazyVim

This guide covers setting up auto-completion, hover documentation (`K`), and enum validation for standard Kubernetes objects and custom CRDs (like ArgoCD and Cert-Manager).

---

## 1. Enable the YAML Extra in LazyVim

LazyVim has a built-in extra module that handles `yaml-language-server` installation and basic Kubernetes schema matching. Add it to your core configuration file (usually `~/.config/nvim/lua/config/lazy.lua`):

```lua
require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Import YAML & Kubernetes support
    { import = "lazyvim.plugins.extras.lang.yaml" },
  },
})
```

---

## 2. Using Public Online Schemas (ArgoCD & Cert-Manager)

For community-maintained CRD schemas, use the **Datree CRDs-catalog**. Create or modify your YAML configuration plugin file (`~/.config/nvim/lua/plugins/yaml.lua`) to bind online URLs to specific filename patterns:

```lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                -- ArgoCD
                ["https://githubusercontent.com"] = "/*argocd*.yaml",
                ["https://githubusercontent.com"] = "/*applicationset*.yaml",
                
                -- Cert-Manager
                ["https://githubusercontent.com"] = "/*certificate*.yaml",
                
                -- Default Kubernetes fallback
                ["kubernetes"] = { "deploy*.yaml", "pod*.yaml", "k8s/*.yaml" },
              },
            },
          },
        },
      },
    },
  },
}
```

---

## 3. The Pro-Trick: Extract Schemas from a Live Cluster

If you deal with private CRDs, custom internal applications, or want to work offline, extract the exact JSON schemas directly from your current Kubernetes context using Datree's CRD extractor tool.

### Step A: Pull schemas using your terminal

```bash
# 1. Create a local directory for your custom schemas
mkdir -p ~/.config/nvim/k8s-schemas

# 2. Run the live extractor script
curl -sL https://githubusercontent.com | bash

# 3. Move the generated files into your Neovim schema folder
mv ~/.datree/crdSchemas/* ~/.config/nvim/k8s-schemas/
```

### Step B: Route LazyVim to your local files

Update `~/.config/nvim/lua/plugins/yaml.lua` to reference your home path dynamically:

```lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                -- Point to local, extracted files
                [os.getenv("HOME") .. "/.config/nvim/k8s-schemas/application_argoproj.io_v1alpha1.json"] = "/*argocd*.yaml",
                [os.getenv("HOME") .. "/.config/nvim/k8s-schemas/certificate_cert-manager.io_v1.json"] = "/*certificate*.yaml",
                
                ["kubernetes"] = { "deploy*.yaml", "pod*.yaml", "k8s/*.yaml" },
              },
            },
          },
        },
      },
    },
  },
}
```

---

## 4. Troubleshooting: Forcing Schema Detection

If the LSP fails to automatically catch a file based on its name, write a **modeline comment** at the absolute top (line 1) of your file to force the mapping:

```yaml
# yaml-language-server: \$schema=https://githubusercontent.com
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
spec:
  # Auto-completion (Ctrl + Space) and Hovers (K) will now activate perfectly
```
