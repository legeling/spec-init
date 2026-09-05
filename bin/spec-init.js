#!/usr/bin/env node

const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");

function fail(message) { throw new Error(message); }
function hostTarget(host) {
  switch (host) {
    case "project":
    case "codex": return path.resolve(".agents", "skills", "spec-init");
    case "claude": return path.join(os.homedir(), ".claude", "skills", "spec-init");
    case "opencode": return path.join(os.homedir(), ".config", "opencode", "skills", "spec-init");
    default: fail(`unsupported host: ${host}`);
  }
}
function inspectTarget(target) {
  let current = path.parse(target).root;
  for (const part of target.slice(current.length).split(path.sep).filter(Boolean)) {
    current = path.join(current, part);
    let stat;
    try { stat = fs.lstatSync(current); }
    catch (error) { if (error.code === "ENOENT") continue; throw error; }
    if (stat.isSymbolicLink() || !stat.isDirectory()) fail(`unsafe directory: ${current}`);
  }
}
function validatePackage(source) {
  for (const file of ["SKILL.md", "scripts/spec-init.sh"]) {
    const target = path.join(source, file);
    if (!fs.existsSync(target) || !fs.lstatSync(target).isFile()) fail(`incomplete skill package: ${file}`);
  }
}
function install() {
  const args = process.argv.slice(2);
  if (args[0] === "install") args.shift();
  let host = "project", target, force = false;
  for (let index = 0; index < args.length; index += 1) {
    const argument = args[index];
    if (argument === "--help" || argument === "-h") {
      console.log("Usage: spec-init [install] [--host project|codex|claude|opencode] [--dir PATH] [--force]\n--force safely replaces an existing skill installation; back up customizations first.");
      return;
    }
    if (argument === "--force") { force = true; continue; }
    const option = argument.split("=", 1)[0];
    if (option !== "--host" && option !== "--dir") fail(`unexpected argument: ${argument}`);
    const value = argument.includes("=") ? argument.slice(option.length + 1) : args[++index];
    if (!value || value.startsWith("--")) fail(`${option} requires a value`);
    if (option === "--host") host = value; else target = value;
  }
  const defaultTarget = hostTarget(host); // Validate host even when --dir is supplied.
  const source = fs.realpathSync(path.resolve(__dirname, "../skills/spec-init"));
  const destination = target === undefined ? defaultTarget : path.resolve(target);
  inspectTarget(destination);
  if (destination === source || destination.startsWith(source + path.sep) || source.startsWith(destination.endsWith(path.sep) ? destination : destination + path.sep)) {
    fail("installation source and destination must not overlap");
  }
  validatePackage(source);
  if (fs.existsSync(destination)) {
    if (!force) fail(`target already exists: ${destination} (use --force to replace it)`);
    validatePackage(destination); // Never remove an unrelated directory with --force.
  }
  fs.mkdirSync(path.dirname(destination), { recursive: true });
  const stage = fs.mkdtempSync(path.join(path.dirname(destination), ".spec-init-install-"));
  const previous = path.join(stage, "previous");
  let retainRecovery = false;
  try {
    const prepared = path.join(stage, "package");
    fs.cpSync(source, prepared, { recursive: true, errorOnExist: true, force: false });
    validatePackage(prepared);
    fs.chmodSync(path.join(prepared, "scripts/spec-init.sh"), 0o755);
    if (fs.existsSync(destination)) {
      if (!force) fail(`target appeared during installation: ${destination}`);
      inspectTarget(destination);
      validatePackage(destination);
      fs.renameSync(destination, previous);
    }
    try { fs.renameSync(prepared, destination); }
    catch (error) {
      if (fs.existsSync(previous)) {
        try { fs.renameSync(previous, destination); }
        catch (restoreError) {
          retainRecovery = true;
          fail(`${error.message}; recovery needed: restore ${previous} to ${destination}: ${restoreError.message}`);
        }
      }
      throw error;
    }
  } finally {
    if (!retainRecovery) fs.rmSync(stage, { recursive: true, force: true });
  }
  console.log(`Installed spec-init to: ${destination}`);
  console.log("Use $spec-init (Codex/project) or /spec-init (Claude Code/OpenCode).");
}
try { install(); }
catch (error) { console.error(`Error: ${error.message}`); process.exitCode = 1; }
