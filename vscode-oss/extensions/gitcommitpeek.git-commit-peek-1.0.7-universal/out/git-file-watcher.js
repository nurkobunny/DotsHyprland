"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.createGitFileWatcher = createGitFileWatcher;
const vscode = __importStar(require("vscode"));
const path = __importStar(require("path"));
const fs = __importStar(require("fs"));
function createGitFileWatcher(refreshFunction) {
    const watchers = [];
    let debounceTimer;
    const debouncedRefresh = () => {
        if (debounceTimer) {
            clearTimeout(debounceTimer);
        }
        debounceTimer = setTimeout(refreshFunction, 2000);
    };
    // Watch key git state files that change on branch switches and updates.
    // - HEAD: points to the current branch (or commit in detached state)
    // - logs/HEAD: updates when HEAD moves (useful for some flows)
    // - index: the staging area, updated by many git operations
    // - refs/heads/**: branch tip refs; changes when branches advance or switch
    const gitPatterns = ["HEAD", "logs/HEAD", "index", "refs/heads/**"];
    // Find the closest git directory.
    // Note: In standard repos, ".git" is a directory. In several common setups,
    // ".git" is a FILE that contains a pointer to the real git dir:
    //   - Worktrees (created via `git worktree`): `.git` contains `gitdir: /path/to/main/.git/worktrees/<name>`
    //   - Submodules: `.git` often contains `gitdir: ../../.git/modules/<submodule>`
    //   - Separate git dir (`git init --separate-git-dir`): `.git` contains `gitdir: /custom/location`
    // We detect both cases and resolve to the actual git directory to attach watchers reliably.
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (workspaceFolder) {
        let dir = workspaceFolder.uri.fsPath;
        let gitDir = null;
        // Check current and parent directories
        while (dir !== path.dirname(dir)) {
            const gitPath = path.join(dir, ".git");
            if (fs.existsSync(gitPath)) {
                try {
                    const stat = fs.statSync(gitPath);
                    if (stat.isDirectory()) {
                        gitDir = gitPath;
                    }
                    else if (stat.isFile()) {
                        // `.git` is a file: parse its contents to find the real git directory.
                        // Format is typically: `gitdir: <absolute-or-relative-path>`.
                        const content = fs.readFileSync(gitPath, "utf8");
                        const match = content.match(/gitdir:\s*(.+)\s*/i);
                        if (match && match[1]) {
                            const candidate = match[1].trim();
                            // Resolve relative paths against the repository root `dir`.
                            gitDir = path.isAbsolute(candidate)
                                ? candidate
                                : path.resolve(dir, candidate);
                        }
                    }
                    if (gitDir) {
                        break;
                    }
                }
                catch {
                    // ignore errors and continue up
                }
            }
            dir = path.dirname(dir);
        }
        if (gitDir) {
            gitPatterns.forEach((pattern) => {
                const watcher = vscode.workspace.createFileSystemWatcher(new vscode.RelativePattern(gitDir, pattern));
                watcher.onDidChange(debouncedRefresh);
                watcher.onDidCreate(debouncedRefresh);
                watcher.onDidDelete(debouncedRefresh);
                watchers.push(watcher);
            });
        }
    }
    return vscode.Disposable.from(...watchers, {
        dispose: () => clearTimeout(debounceTimer),
    });
}
//# sourceMappingURL=git-file-watcher.js.map