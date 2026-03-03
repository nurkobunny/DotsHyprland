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
exports.activate = activate;
const vscode = __importStar(require("vscode"));
const git_file_watcher_1 = require("./git-file-watcher");
const file_tree_1 = require("./tree-data-providers/file-tree");
const util_1 = require("./util");
const list_1 = require("./tree-data-providers/list");
async function activate(context) {
    const workspaceRoot = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
    let currentProvider;
    // Function to create and register the appropriate provider
    function createProvider() {
        const config = vscode.workspace.getConfiguration("git-commit-peek");
        const providerType = config.get("treeViewType", "list");
        if (providerType === "tree") {
            currentProvider = new file_tree_1.FileTreeDataProvider(workspaceRoot);
        }
        else {
            currentProvider = new list_1.ListTreeDataProvider(workspaceRoot);
        }
        vscode.window.registerTreeDataProvider("lastCommitFiles", currentProvider);
        currentProvider.setFiles((0, util_1.getChangedGitFiles)());
    }
    // Initial provider creation
    createProvider();
    context.subscriptions.push(vscode.workspace.onDidChangeConfiguration((event) => {
        if (event.affectsConfiguration("git-commit-peek.treeViewType")) {
            createProvider();
        }
    }));
    // Ensure watcher stays alive and is disposed on deactivate
    const watcherDisposable = (0, git_file_watcher_1.createGitFileWatcher)(() => {
        const files = (0, util_1.getChangedGitFiles)();
        currentProvider.setFiles(files);
    });
    context.subscriptions.push(watcherDisposable);
}
//# sourceMappingURL=extension.js.map