---
title: 2026-05-28 · Intel N100 迷你主机 PCIe 硬件直通与虚拟化知识整理
created: 2026-05-28T18:28:20+08:00
source: ai
source_skill: obsidian-sync-example
related:
  - https://docs.proxmox.com/pve-admin-guide-8.html
tags: [ai-generated, knowledge, intel-n100, pci-passthrough, iommu, virtualization]
---

# 🧠 Intel N100 迷你主机 PCIe 硬件直通与虚拟化知识整理

## 1. Intel N100 处理器虚拟化特性
Intel N100 (Alder Lake-N) 凭借其极低的功耗与出色的多核效率，成为了目前最顶级的家庭软路由与轻量 NAS 虚拟化平台底座。
- **核心支持**：完美支持 Intel VT-x（处理器虚拟化）、VT-d（网卡/显卡物理直通）以及 EPT（二级地址转换）。
- **核显直通**：内置 Intel UHD Graphics 24EU 核心显卡，支持直接直通给 `fnOS` 虚拟机实现 4K 流媒体硬件级解码或 Plex 转码。

## 2. PVE PCIe 网卡直通 (IOMMU) 核心配置逻辑
在 PVE 8.x 中将双 2.5G 网卡中的一块网卡直接分配给 iStoreOS 软路由，能够最大化网络吞吐并降低 CPU 推理开销。

### 2.1 开启 IOMMU 支持
编辑 PVE 宿主机的 `/etc/default/grub`，在 `GRUB_CMDLINE_LINUX_DEFAULT` 中追加：
```bash
intel_iommu=on iommu=pt
```
更新 Grub 配置并重启系统：
```bash
update-grub
```

### 2.2 验证直通组划分 (IOMMU Groups)
运行以下命令验证网卡是否处于独立的 IOMMU 组，防范设备冲突：
```bash
find /sys/kernel/iommu_groups/ -type l
```

### 2.3 直通与防冲突配置
为了防范直通网卡后导致宿主机网络瘫痪，必须将 `nic1` 物理网口的控制权完全交给 iStoreOS。直通后，宿主机 PVE 无法再通过该网口收发流量。详见 [[PVE 配置 iStoreOS 标准操作流程 (SOP)]]。

## 3. 防灾与集群同步
在多物理节点（例如 J4125 宿主与备用 N100 主机）并存的环境下，通过 `sync_nodes.py` 脚本定时比对和同步各物理节点上的 KVM 虚拟机状态，是保障智能网络永不断流的终极容灾预案。

---
*整理人：Antigravity AI*
