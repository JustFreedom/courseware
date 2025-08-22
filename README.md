# Miss 课件系统

一个现代化的课件制作和展示系统，支持语音播放、角色对话等功能。

## 功能特性

### 🎯 语音播放组件
- **智能语音选择**：自动检测中英文内容，选择合适的语音
- **标点符号过滤**：自动过滤标点符号，避免朗读干扰
- **英文发音优化**：优化冠词、连词等单词的发音（如 "a" 读作 [ə] 而不是 [eɪ]）
- **连贯发音**：确保英文句子完整连贯播放，不会只读第一个单词
- **英文智能断句**：自动将长英文句子分成短句，提高可读性（如 "a funny cat, a big pizza" 分成两句播放）
- **角色语音**：支持不同角色的个性化语音设置
- **混合语言**：智能处理中英文混合内容

### 🎨 课件制作
- 支持多种课件格式
- 角色对话系统
- 响应式设计

## 语音播放组件使用说明

### 基本用法

```javascript
// 创建语音播放器实例
const speechPlayer = new SpeechPlayer();

// 播放文本
speechPlayer.speak("Hello, world!", "🦊");

// 使用英文语音播放
speechPlayer.speak("a funny cat", "🦊", { englishAsEnglish: true });

// 启用混合语言播放
speechPlayer.speak("这是一只 a funny cat", "🦊", { mixedLanguage: true });
```

### 主要改进

#### 1. 标点符号过滤
- 自动过滤逗号、句号、感叹号等标点符号
- 保留必要的空格和换行
- 避免朗读干扰，提升语音质量

#### 2. 英文发音优化
- **冠词优化**：`a` → [ə], `an` → [ən], `the` → [ðə]
- **连词优化**：`and` → [ənd], `or` → [ɔː], `but` → [bət]
- **介词优化**：`of` → [əv], `to` → [tə], `for` → [fə]
- **助动词优化**：`is` → [ɪz], `are` → [ə], `have` → [həv]

#### 3. 连贯发音
- 确保英文句子完整播放，不会中断
- 智能分段处理中英文混合内容
- 优化语速和语音切换

#### 4. 英文智能断句
- **逗号断句**：在逗号后自动断句（如 "a funny cat, a big pizza" → "a funny cat." + "a big pizza."）
- **连词断句**：在 and, or, but 等连词前断句
- **介词断句**：在 of, in, on, at 等介词前断句
- **从句断句**：在 that, which, who 等从句引导词前断句
- **长度优化**：如果句子超过8个单词，自动寻找合适断句点
- **停顿控制**：句子间自动添加500ms停顿，确保清晰度

### 断句示例

```javascript
// 输入文本
"a funny cat, a big pizza, and a small dog."

// 断句结果
[
  "a funny cat.",
  "a big pizza.",
  "and a small dog."
]

// 播放效果：依次播放每个短句，中间有停顿
```

### 配置选项

```javascript
// 语音设置
speechPlayer.setVoiceSettings({
    rate: 0.9,      // 语速 (0.1-10)
    pitch: 1.0,     // 音调 (0-2)
    volume: 1.0     // 音量 (0-1)
});

// 角色语音配置
speechPlayer.addCharacterVoice('🦊', {
    name: 'zh-CN-XiaoxiaoNeural',      // 中文语音
    englishName: 'en-US-JennyNeural',   // 英文语音
    rate: 0.9,                          // 中文语速
    englishRate: 0.7                    // 英文语速
});
```

## 测试

### 基础功能测试
运行 `test-speech.html` 来测试语音播放组件的各项功能：

1. **标点符号过滤测试**：验证标点符号是否被正确过滤
2. **英文发音优化测试**：检查冠词和连词的发音优化
3. **语音播放测试**：测试实际的语音播放效果
4. **混合语言测试**：验证中英文混合内容的处理

### 中英文混合播放测试
运行 `test-mixed-language.html` 来专门测试中英文混合播放功能：

1. **问题复现测试**：测试您提到的具体问题（"名词就是人、事、物的名字，比如 student, school, pizza。"）
2. **文本分割测试**：验证中英文文本的分割逻辑
3. **语音库信息**：查看当前可用的语音库
4. **调试日志**：实时查看播放过程的调试信息

## 语音库下载

语音播放组件采用智能语音选择策略，优先使用浏览器默认的高质量语音：

- **浏览器默认语音**：优先使用系统内置的高质量语音（如Neural、Google、Samantha、Alex等）
- **本地语音库**：已预先下载到 `voices/` 目录，作为备用选项
- **开源语音库**：支持eSpeak、Festival等开源语音引擎
- **系统语音**：使用浏览器内置的Web Speech API

### 语音选择优先级
1. **浏览器默认高质量语音**：优先使用系统内置的Neural、Google等高质量语音
2. **目标语言语音**：根据内容语言选择对应的语音
3. **备用语音**：使用同语言的备用语音
4. **本地语音库**：作为最后的备用选项

### 本地语音库特点
- ✅ 完全免费，无版权问题
- ✅ 本地运行，无需网络连接
- ✅ 作为备用选项，不主动使用
- ✅ 支持中英文等多种语言
- ✅ 包含发音优化和断句规则

### 使用本地语音库（备用）
```javascript
// 获取本地语音库信息
const localVoices = speechPlayer.getLocalVoiceLibrary();

// 强制使用本地语音库（不推荐，除非浏览器语音质量很差）
speechPlayer.speakWithLocalVoice(text, 'espeak-english');
```

## 文件结构

```
miss/
├── js/
│   └── speech-player.js      # 语音播放组件核心代码
├── voices/                   # 本地语音库配置
│   ├── README.md            # 语音库使用说明
│   ├── espeak-english.json # eSpeak英文语音库配置
│   ├── espeak-chinese.json # eSpeak中文语音库配置
│   └── festival-english.json # Festival英文语音库配置
├── english/                  # 英语课件
├── test-speech.html         # 语音播放基础测试页面
├── test-mixed-language.html # 中英文混合播放测试页面
└── README.md                # 项目说明文档
```

## 浏览器支持

- Chrome 33+
- Firefox 49+
- Safari 7+
- Edge 14+

## 许可证

MIT License


