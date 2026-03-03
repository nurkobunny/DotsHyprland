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
exports.ListTreeDataProvider = void 0;
const vscode = __importStar(require("vscode"));
const util_1 = require("./util");
const base_tree_provider_1 = require("./base-tree-provider");
const path_1 = __importDefault(require("path"));
class ListTreeDataProvider extends base_tree_provider_1.BaseTreeDataProvider {
    getTreeItem(element) {
        return element;
    }
    getChildren() {
        try {
            const listFiles = this.files.map((file) => new ListFile(file));
            return Promise.resolve(listFiles);
        }
        catch (error) {
            vscode.window.showErrorMessage("Failed to load last commit files: " + error);
            return Promise.resolve([]);
        }
    }
}
exports.ListTreeDataProvider = ListTreeDataProvider;
class ListFile extends vscode.TreeItem {
    constructor(file) {
        const filename = path_1.default.basename(file.relativePath);
        super(filename, vscode.TreeItemCollapsibleState.None);
        this.command = {
            command: "vscode.open",
            title: "Open File",
            arguments: [vscode.Uri.file(file.absolutePath)],
        };
        this.tooltip = `${file.status}: ${file.absolutePath}`;
        this.iconPath = (0, util_1.getIconForGitStatus)(file.status);
        this.description = file.relativePath;
    }
}
//# sourceMappingURL=list.js.map