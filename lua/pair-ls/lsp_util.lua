-- From https://github.com/neovim/nvim-lspconfig
-- Copyright Neovim contributors. All rights reserved.
--
-- nvim-lsp is licensed under the terms of the Apache 2.0 license.
--
-- nvim-lsp's license follows:
--
-- ====
--                                  Apache License
--                            Version 2.0, January 2004
--                         http://www.apache.org/licenses/
--
--    TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION
--
--    1. Definitions.
--
--       "License" shall mean the terms and conditions for use, reproduction,
--       and distribution as defined by Sections 1 through 9 of this document.
--
--       "Licensor" shall mean the copyright owner or entity authorized by
--       the copyright owner that is granting the License.
--
--       "Legal Entity" shall mean the union of the acting entity and all
--       other entities that control, are controlled by, or are under common
--       control with that entity. For the purposes of this definition,
--       "control" means (i) the power, direct or indirect, to cause the
--       direction or management of such entity, whether by contract or
--       otherwise, or (ii) ownership of fifty percent (50%) or more of the
--       outstanding shares, or (iii) beneficial ownership of such entity.
--
--       "You" (or "Your") shall mean an individual or Legal Entity
--       exercising permissions granted by this License.
--
--       "Source" form shall mean the preferred form for making modifications,
--       including but not limited to software source code, documentation
--       source, and configuration files.
--
--       "Object" form shall mean any form resulting from mechanical
--       transformation or translation of a Source form, including but
--       not limited to compiled object code, generated documentation,
--       and conversions to other media types.
--
--       "Work" shall mean the work of authorship, whether in Source or
--       Object form, made available under the License, as indicated by a
--       copyright notice that is included in or attached to the work
--       (an example is provided in the Appendix below).
--
--       "Derivative Works" shall mean any work, whether in Source or Object
--       form, that is based on (or derived from) the Work and for which the
--       editorial revisions, annotations, elaborations, or other modifications
--       represent, as a whole, an original work of authorship. For the purposes
--       of this License, Derivative Works shall not include works that remain
--       separable from, or merely link (or bind by name) to the interfaces of,
--       the Work and Derivative Works thereof.
--
--       "Contribution" shall mean any work of authorship, including
--       the original version of the Work and any modifications or additions
--       to that Work or Derivative Works thereof, that is intentionally
--       submitted to Licensor for inclusion in the Work by the copyright owner
--       or by an individual or Legal Entity authorized to submit on behalf of
--       the copyright owner. For the purposes of this definition, "submitted"
--       means any form of electronic, verbal, or written communication sent
--       to the Licensor or its representatives, including but not limited to
--       communication on electronic mailing lists, source code control systems,
--       and issue tracking systems that are managed by, or on behalf of, the
--       Licensor for the purpose of discussing and improving the Work, but
--       excluding communication that is conspicuously marked or otherwise
--       designated in writing by the copyright owner as "Not a Contribution."
--
--       "Contributor" shall mean Licensor and any individual or Legal Entity
--       on behalf of whom a Contribution has been received by Licensor and
--       subsequently incorporated within the Work.
--
--    2. Grant of Copyright License. Subject to the terms and conditions of
--       this License, each Contributor hereby grants to You a perpetual,
--       worldwide, non-exclusive, no-charge, royalty-free, irrevocable
--       copyright license to reproduce, prepare Derivative Works of,
--       publicly display, publicly perform, sublicense, and distribute the
--       Work and such Derivative Works in Source or Object form.
--
--    3. Grant of Patent License. Subject to the terms and conditions of
--       this License, each Contributor hereby grants to You a perpetual,
--       worldwide, non-exclusive, no-charge, royalty-free, irrevocable
--       (except as stated in this section) patent license to make, have made,
--       use, offer to sell, sell, import, and otherwise transfer the Work,
--       where such license applies only to those patent claims licensable
--       by such Contributor that are necessarily infringed by their
--       Contribution(s) alone or by combination of their Contribution(s)
--       with the Work to which such Contribution(s) was submitted. If You
--       institute patent litigation against any entity (including a
--       cross-claim or counterclaim in a lawsuit) alleging that the Work
--       or a Contribution incorporated within the Work constitutes direct
--       or contributory patent infringement, then any patent licenses
--       granted to You under this License for that Work shall terminate
--       as of the date such litigation is filed.
--
--    4. Redistribution. You may reproduce and distribute copies of the
--       Work or Derivative Works thereof in any medium, with or without
--       modifications, and in Source or Object form, provided that You
--       meet the following conditions:
--
--       (a) You must give any other recipients of the Work or
--           Derivative Works a copy of this License; and
--
--       (b) You must cause any modified files to carry prominent notices
--           stating that You changed the files; and
--
--       (c) You must retain, in the Source form of any Derivative Works
--           that You distribute, all copyright, patent, trademark, and
--           attribution notices from the Source form of the Work,
--           excluding those notices that do not pertain to any part of
--           the Derivative Works; and
--
--       (d) If the Work includes a "NOTICE" text file as part of its
--           distribution, then any Derivative Works that You distribute must
--           include a readable copy of the attribution notices contained
--           within such NOTICE file, excluding those notices that do not
--           pertain to any part of the Derivative Works, in at least one
--           of the following places: within a NOTICE text file distributed
--           as part of the Derivative Works; within the Source form or
--           documentation, if provided along with the Derivative Works; or,
--           within a display generated by the Derivative Works, if and
--           wherever such third-party notices normally appear. The contents
--           of the NOTICE file are for informational purposes only and
--           do not modify the License. You may add Your own attribution
--           notices within Derivative Works that You distribute, alongside
--           or as an addendum to the NOTICE text from the Work, provided
--           that such additional attribution notices cannot be construed
--           as modifying the License.
--
--       You may add Your own copyright statement to Your modifications and
--       may provide additional or different license terms and conditions
--       for use, reproduction, or distribution of Your modifications, or
--       for any such Derivative Works as a whole, provided Your use,
--       reproduction, and distribution of the Work otherwise complies with
--       the conditions stated in this License.
--
--    5. Submission of Contributions. Unless You explicitly state otherwise,
--       any Contribution intentionally submitted for inclusion in the Work
--       by You to the Licensor shall be under the terms and conditions of
--       this License, without any additional terms or conditions.
--       Notwithstanding the above, nothing herein shall supersede or modify
--       the terms of any separate license agreement you may have executed
--       with Licensor regarding such Contributions.
--
--    6. Trademarks. This License does not grant permission to use the trade
--       names, trademarks, service marks, or product names of the Licensor,
--       except as required for reasonable and customary use in describing the
--       origin of the Work and reproducing the content of the NOTICE file.
--
--    7. Disclaimer of Warranty. Unless required by applicable law or
--       agreed to in writing, Licensor provides the Work (and each
--       Contributor provides its Contributions) on an "AS IS" BASIS,
--       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
--       implied, including, without limitation, any warranties or conditions
--       of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
--       PARTICULAR PURPOSE. You are solely responsible for determining the
--       appropriateness of using or redistributing the Work and assume any
--       risks associated with Your exercise of permissions under this License.
--
--    8. Limitation of Liability. In no event and under no legal theory,
--       whether in tort (including negligence), contract, or otherwise,
--       unless required by applicable law (such as deliberate and grossly
--       negligent acts) or agreed to in writing, shall any Contributor be
--       liable to You for damages, including any direct, indirect, special,
--       incidental, or consequential damages of any character arising as a
--       result of this License or out of the use or inability to use the
--       Work (including but not limited to damages for loss of goodwill,
--       work stoppage, computer failure or malfunction, or any and all
--       other commercial damages or losses), even if such Contributor
--       has been advised of the possibility of such damages.
--
--    9. Accepting Warranty or Additional Liability. While redistributing
--       the Work or Derivative Works thereof, You may choose to offer,
--       and charge a fee for, acceptance of support, warranty, indemnity,
--       or other liability obligations and/or rights consistent with this
--       License. However, in accepting such obligations, You may act only
--       on Your own behalf and on Your sole responsibility, not on behalf
--       of any other Contributor, and only if You agree to indemnify,
--       defend, and hold each Contributor harmless for any liability
--       incurred by, or claims asserted against, such Contributor by reason
--       of your accepting any such warranty or additional liability.
--
--    END OF TERMS AND CONDITIONS

-- This file has been modified from the original to exclude unecessary functions
local vim = vim
local validate = vim.validate
local uv = vim.loop

local M = {}

M.script_path = function()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*[/\\])")
end

-- Some path utilities
M.path = (function()
  local is_windows = uv.os_uname().version:match("Windows")

  local function sanitize(path)
    if is_windows then
      path = path:sub(1, 1):upper() .. path:sub(2)
      path = path:gsub("\\", "/")
    end
    return path
  end

  local function exists(filename)
    local stat = uv.fs_stat(filename)
    return stat and stat.type or false
  end

  local function is_dir(filename)
    return exists(filename) == "directory"
  end

  local function is_file(filename)
    return exists(filename) == "file"
  end

  local function is_fs_root(path)
    if is_windows then
      return path:match("^%a:$")
    else
      return path == "/"
    end
  end

  local function is_absolute(filename)
    if is_windows then
      return filename:match("^%a:") or filename:match("^\\\\")
    else
      return filename:match("^/")
    end
  end

  local function dirname(path)
    local strip_dir_pat = "/([^/]+)$"
    local strip_sep_pat = "/$"
    if not path or #path == 0 then
      return
    end
    local result = path:gsub(strip_sep_pat, ""):gsub(strip_dir_pat, "")
    if #result == 0 then
      if is_windows then
        return path:sub(1, 2):upper()
      else
        return "/"
      end
    end
    return result
  end

  local function path_join(...)
    return table.concat(vim.tbl_flatten({ ... }), "/")
  end

  -- Traverse the path calling cb along the way.
  local function traverse_parents(path, cb)
    path = uv.fs_realpath(path)
    local dir = path
    -- Just in case our algo is buggy, don't infinite loop.
    for _ = 1, 100 do
      dir = dirname(dir)
      if not dir then
        return
      end
      -- If we can't ascend further, then stop looking.
      if cb(dir, path) then
        return dir, path
      end
      if is_fs_root(dir) then
        break
      end
    end
  end

  -- Iterate the path until we find the rootdir.
  local function iterate_parents(path)
    local function it(_, v)
      if v and not is_fs_root(v) then
        v = dirname(v)
      else
        return
      end
      if v and uv.fs_realpath(v) then
        return v, path
      else
        return
      end
    end
    return it, path, path
  end

  local function is_descendant(root, path)
    if not path then
      return false
    end

    local function cb(dir, _)
      return dir == root
    end

    local dir, _ = traverse_parents(path, cb)

    return dir == root
  end

  return {
    is_dir = is_dir,
    is_file = is_file,
    is_absolute = is_absolute,
    exists = exists,
    dirname = dirname,
    join = path_join,
    sanitize = sanitize,
    traverse_parents = traverse_parents,
    iterate_parents = iterate_parents,
    is_descendant = is_descendant,
  }
end)()

function M.search_ancestors(startpath, func)
  validate({ func = { func, "f" } })
  if func(startpath) then
    return startpath
  end
  local guard = 100
  for path in M.path.iterate_parents(startpath) do
    -- Prevent infinite recursion if our algorithm breaks
    guard = guard - 1
    if guard == 0 then
      return
    end

    if func(path) then
      return path
    end
  end
end

function M.root_pattern(...)
  local patterns = vim.tbl_flatten({ ... })
  local function matcher(path)
    for _, pattern in ipairs(patterns) do
      for _, p in ipairs(vim.fn.glob(M.path.join(path, pattern), true, true)) do
        if M.path.exists(p) then
          return path
        end
      end
    end
  end
  return function(startpath)
    return M.search_ancestors(startpath, matcher)
  end
end
return M
