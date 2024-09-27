// SPDX-FileCopyrightText: 2023 torzu Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

package org.torzu.torzu_emu.utils

import android.content.Context
import android.net.Uri
import androidx.documentfile.provider.DocumentFile
import java.io.File
import java.util.*
import org.torzu.torzu_emu.model.MinimalDocumentFile

class DocumentsTree {
    private var root: DocumentsNode? = null

    fun setRoot(rootUri: Uri?) {
        root = DocumentsNode().apply {
            uri = rootUri
            isDirectory = true
        }
    }

    fun openContentUri(context: Context, filepath: String, openMode: String?): Int {
        val node = resolvePath(filepath) ?: return -1
        return FileUtil.openContentUri(node.uri.toString(), openMode)
    }

    fun getFileSize(context: Context, filepath: String): Long {
        val node = resolvePath(filepath)
        return if (node == null || node.isDirectory) {
            0
        } else {
            FileUtil.getFileSize(node.uri.toString())
        }
    }

    fun exists(filepath: String): Boolean {
        return resolvePath(filepath) != null
    }

    fun isDirectory(filepath: String): Boolean {
        val node = resolvePath(filepath)
        return node != null && node.isDirectory
    }

    fun getParentDirectory(filepath: String): String {
        val node = resolvePath(filepath) ?: return filepath
        val parentNode = node.parent
        return if (parentNode != null && parentNode.isDirectory) {
            parentNode.uri?.toString() ?: filepath
        } else {
            node.uri?.toString() ?: filepath
        }
    }

    fun getFilename(filepath: String): String {
        val node = resolvePath(filepath)
        return node?.name ?: filepath
    }

    private fun resolvePath(filepath: String): DocumentsNode? {
        val tokens = StringTokenizer(filepath, File.separator, false)
        var iterator = root
        while (tokens.hasMoreTokens()) {
            val token = tokens.nextToken()
            if (token.isEmpty()) continue
            iterator = find(iterator, token)
            if (iterator == null) return null
        }
        return iterator
    }

    private fun find(parent: DocumentsNode?, filename: String): DocumentsNode? {
        if (parent == null) return null
        if (parent.isDirectory && !parent.loaded) {
            structTree(parent)
        }
        return parent.children[filename]
    }

    /**
     * Construct current level directory tree
     * @param parent parent node of this level
     */
    private fun structTree(parent: DocumentsNode) {
        val uri = parent.uri ?: return
        val documents = FileUtil.listFiles(uri)
        for (document in documents) {
            val node = DocumentsNode(document)
            node.parent = parent
            parent.children[node.name] = node
        }
        parent.loaded = true
    }

    private class DocumentsNode {
        var parent: DocumentsNode? = null
        val children: MutableMap<String?, DocumentsNode> = HashMap()
        var name: String? = null
        var uri: Uri? = null
        var loaded = false
        var isDirectory = false

        constructor()
        constructor(document: MinimalDocumentFile) {
            name = document.filename
            uri = document.uri
            isDirectory = document.isDirectory
            loaded = !isDirectory
        }

        private constructor(document: DocumentFile, isCreateDir: Boolean) {
            name = document.name
            uri = document.uri
            isDirectory = isCreateDir
            loaded = true
        }

        private fun rename(name: String) {
            parent?.let {
                it.children.remove(this.name)
                this.name = name
                it.children[name] = this
            }
        }
    }

    companion object {
        fun isNativePath(path: String): Boolean {
            return path.isNotEmpty() && path[0] == '/'
        }
    }
}
