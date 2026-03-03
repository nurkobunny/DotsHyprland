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
exports.getChangedGitFiles = getChangedGitFiles;
exports.getIconForGitStatus = getIconForGitStatus;
const child_process_1 = require("child_process");
const path = __importStar(require("path"));
const vscode = __importStar(require("vscode"));
function getChangedGitFiles() {
    const repoPath = vscode.workspace.workspaceFolders?.[0].uri.fsPath;
    if (!repoPath) {
        return [];
    }
    // Format: A\tfile.txt\nM\tfile2.txt\nD\tfile3.txt
    const output = (0, child_process_1.execSync)('git show --relative --name-status --pretty="" HEAD', {
        cwd: repoPath,
    }).toString();
    return output
        .trim()
        .split("\n")
        .map((line) => {
        const [status, relativePath] = line.split(/\t/);
        if (!relativePath) {
            return undefined;
        }
        return {
            relativePath,
            status,
            absolutePath: path.join(repoPath, relativePath),
        };
    })
        .filter((a) => a !== undefined);
}
function getIconForGitStatus(status) {
    switch (status) {
        case "A":
            return new vscode.ThemeIcon("diff-added");
        case "M":
            return new vscode.ThemeIcon("diff-modified");
        case "D":
            return new vscode.ThemeIcon("diff-removed");
        default:
            return new vscode.ThemeIcon("file");
    }
}
//# sourceMappingURL=util.js.map