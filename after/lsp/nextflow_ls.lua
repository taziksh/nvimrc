return {
  cmd = { "java", "-jar", vim.fn.expand("~/.local/share/nextflow-language-server/language-server-all.jar") },
  filetypes = { "nextflow" },
  root_markers = { "nextflow.config", ".git" },
  settings = {
    nextflow = {
      files = {
        exclude = { ".git", ".nf-test", "work" },
      },
    },
  },
}
