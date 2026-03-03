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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.FileTreeDataProvider = void 0;
const path_1 = __importDefault(require("path"));
const vscode = __importStar(require("vscode"));
const util_1 = require("./util");
const base_1 = require("./tree-data-providers/base");
class FileTreeDataProvider extends base_1.BaseTreeDataProvider {
    getTreeItem(element) {
        return element;
    }
    getChildren(element) {
        if (!this.workspaceRoot) {
            vscode.window.showInformationMessage("No workspace folder");
            return Promise.resolve([]);
        }
        if (element) {
            // Get children of a directory
            return Promise.resolve(this.getDirectoryChildren(element.filePath));
        }
        else {
            // Get root items
            return Promise.resolve(this.getRootItems());
        }
    }
    getRootItems() {
        return this.getDirectoryItems(this.workspaceRoot);
    }
    getDirectoryChildren(dirPath) {
        return this.getDirectoryItems(dirPath);
    }
    /**
     * Shared logic for getting items (files and directories) under a given directory path.
     */
    getDirectoryItems(baseDir) {
        const items = [];
        const processedDirs = new Set();
        // Filter files that are children of this directory
        const childFiles = this.files.filter((file) => {
            const relativePath = path_1.default.relative(baseDir, file.absolutePath);
            return !relativePath.startsWith("..") && relativePath !== "";
        });
        for (const file of childFiles) {
            const relativePath = path_1.default.relative(baseDir, file.absolutePath);
            const parts = relativePath.split(path_1.default.sep);
            if (parts.length === 1) {
                // Direct child file
                items.push(new FileTreeItem(parts[0], file.absolutePath, false, file.status));
            }
            else {
                // Child directory
                const childDir = parts[0];
                const childDirPath = path_1.default.join(baseDir, childDir);
                if (!processedDirs.has(childDir)) {
                    processedDirs.add(childDir);
                    items.push(new FileTreeItem(childDir, childDirPath, true, file.status));
                }
            }
        }
        return items.sort((a, b) => {
            // Directories first, then files
            if (a.isDirectory && !b.isDirectory)
                return -1;
            if (!a.isDirectory && b.isDirectory)
                return 1;
            return a.label.localeCompare(b.label);
        });
    }
}
exports.FileTreeDataProvider = FileTreeDataProvider;
class FileTreeItem extends vscode.TreeItem {
    label;
    filePath;
    isDirectory;
    status;
    constructor(label, filePath, isDirectory, status) {
        super(label, vscode.TreeItemCollapsibleState.Expanded);
        this.label = label;
        this.filePath = filePath;
        this.isDirectory = isDirectory;
        this.status = status;
        this.tooltip = this.filePath;
        this.contextValue = isDirectory ? "directory" : "file";
        if (!isDirectory) {
            this.command = {
                command: "vscode.open",
                title: "Open File",
                arguments: [vscode.Uri.file(filePath)],
            };
            this.iconPath = (0, util_1.getIconForGitStatus)(status);
        }
        else {
            this.iconPath = new vscode.ThemeIcon("folder");
        }
    }
}
//# sourceMappingURL=file-tree.js.map