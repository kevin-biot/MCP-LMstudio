// utils/path-utils.ts - Path validation and security utilities
import fs from "fs/promises";
import path from "path";
import os from 'os';

/**
 * Normalize path consistently across platforms
 */
export function normalizePath(p: string): string {
  return path.normalize(p);
}

/**
 * Expand home directory (~) in file paths
 */
export function expandHome(filepath: string): string {
  if (filepath.startsWith('~/') || filepath === '~') {
    return path.join(os.homedir(), filepath.slice(1));
  }
  return filepath;
}

/**
 * Validate that a path is within allowed directories and resolve symlinks
 * @param requestedPath The path to validate
 * @param allowedDirectories Array of allowed directory paths
 * @returns The resolved absolute path if valid
 * @throws Error if path is not allowed
 */
export async function validatePath(requestedPath: string, allowedDirectories: string[]): Promise<string> {
  const expandedPath = expandHome(requestedPath);
  const absolute = path.isAbsolute(expandedPath)
    ? path.resolve(expandedPath)
    : path.resolve(process.cwd(), expandedPath);

  const normalizedRequested = normalizePath(absolute);

  // Check if path is within allowed directories
  const isAllowed = allowedDirectories.some(dir => normalizedRequested.startsWith(dir));
  if (!isAllowed) {
    throw new Error(`Access denied - path outside allowed directories: ${absolute} not in ${allowedDirectories.join(', ')}`);
  }

  // Handle symlinks by checking their real path
  try {
    const realPath = await fs.realpath(absolute);
    const normalizedReal = normalizePath(realPath);
    const isRealPathAllowed = allowedDirectories.some(dir => normalizedReal.startsWith(dir));
    if (!isRealPathAllowed) {
      throw new Error("Access denied - symlink target outside allowed directories");
    }
    return realPath;
  } catch (error) {
    // For new files that don't exist yet, verify parent directory
    const parentDir = path.dirname(absolute);
    try {
      const realParentPath = await fs.realpath(parentDir);
      const normalizedParent = normalizePath(realParentPath);
      const isParentAllowed = allowedDirectories.some(dir => normalizedParent.startsWith(dir));
      if (!isParentAllowed) {
        throw new Error("Access denied - parent directory outside allowed directories");
      }
      return absolute;
    } catch {
      throw new Error(`Parent directory does not exist: ${parentDir}`);
    }
  }
}

/**
 * Parse command line arguments for the server
 */
export function parseArguments(args: string[]) {
  const httpMode = args.includes('--http');
  const portArg = args.find(arg => arg.startsWith('--port='));
  const port = portArg ? parseInt(portArg.split('=')[1]) : 8080;
  
  // Filter out flags to get directory arguments
  const directoryArgs = args.filter(arg => !arg.startsWith('--'));
  
  return {
    httpMode,
    port,
    directoryArgs
  };
}
