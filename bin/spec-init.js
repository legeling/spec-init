#!/usr/bin/env node

const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");

function printUsage() {
  console.log(`Usage:
  spec-init [install] [--host HOST] [--dir PATH] [--force]

Installs the spec-init skill.

Options:
  --host HOST   project | codex | claude | opencode (default: project)
  --dir PATH    install to an explicit directory
  --force       replace an existing installation
  -h, --help    show this help message

Examples:
  npx --yes github:legeling/spec-init
  npx --yes github:legeling/spec-init --host claude
  npx --yes github:legeling/spec-init --dir ./.agents/skills/spec-init --force`);
}

function fail(message) {
  console.error(`Error: ${message}`);
  process.exit(1);
}

function resolveHostTarget(host) {
  switch (host) {
    case "project":
    case "codex":
      return path.resolve(process.cwd(), ".agents", "skills", "spec-init");
    case "claude":
      return path.join(os.homedir(), ".claude", "skills", "spec-init");
    case "opencode":
      return path.join(os.homedir(), ".config", "opencode", "skills", "spec-init");
    default:
      fail(`unsupported host: ${host}. Supported hosts: project, codex, claude, opencode`);
  }
}

const args = process.argv.slice(2);

if (args.includes("-h") || args.includes("--help")) {
  printUsage();
  process.exit(0);
}

if (args[0] === "install") {
  args.shift();
}

let host = "project";
let targetDir = "";
let force = false;

for (let index = 0; index < args.length; index += 1) {
  const current = args[index];

  if (current === "--host") {
    host = args[index + 1] || "";
    index += 1;
    continue;
  }

  if (current.startsWith("--host=")) {
    host = current.slice("--host=".length);
    continue;
  }

  if (current === "--dir") {
    targetDir = args[index + 1] || "";
    index += 1;
    continue;
  }

  if (current.startsWith("--dir=")) {
    targetDir = current.slice("--dir=".length);
    continue;
  }

  if (current === "--force") {
    force = true;
    continue;
  }

  fail(`unexpected argument: ${current}`);
}

if (!host) {
  fail("--host requires a value");
}

if (args.includes("--dir") && !targetDir) {
  fail("--dir requires a value");
}

const packageRoot = path.resolve(__dirname, "..");
const sourceDir = path.join(packageRoot, "skills", "spec-init");

if (!fs.existsSync(sourceDir)) {
  fail(`skill source not found: ${sourceDir}`);
}

const destinationDir = targetDir ? path.resolve(targetDir) : resolveHostTarget(host);

if (fs.existsSync(destinationDir)) {
  if (!force) {
    fail(`target already exists: ${destinationDir} (use --force to replace it)`);
  }

  fs.rmSync(destinationDir, { recursive: true, force: true });
}

fs.mkdirSync(path.dirname(destinationDir), { recursive: true });
fs.cpSync(sourceDir, destinationDir, { recursive: true });

const scaffoldScript = path.join(destinationDir, "scripts", "spec-init.sh");
if (fs.existsSync(scaffoldScript)) {
  fs.chmodSync(scaffoldScript, 0o755);
}

console.log(`Installed spec-init to: ${destinationDir}`);
console.log("Next step:");
console.log("- Codex / project-local: use $spec-init or the skill picker");
console.log("- Claude Code / OpenCode: use /spec-init after the host reloads skills if needed");
