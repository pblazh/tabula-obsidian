import { App, PluginSettingTab, Setting } from 'obsidian'
import type TabulaPlugin from './main'

export class TabulaSettingTab extends PluginSettingTab {
  plugin: TabulaPlugin

  constructor(app: App, plugin: TabulaPlugin) {
    super(app, plugin)
    this.plugin = plugin
  }

  display(): void {
    const { containerEl } = this

    containerEl.empty()

    new Setting(containerEl)
      .setName('Auto-execute on save')
      .setDesc(
        'Automatically execute tabula scripts when saving Markdown files.',
      )
      .addToggle((toggle) =>
        toggle
          .setValue(this.plugin.settings.autoExecution)
          .onChange((value) => {
            this.plugin.settings.autoExecution = value
            this.plugin.saveSettings()
          }),
      )

    new Setting(containerEl)
      .setName('Tabula executable path')
      .setDesc(
        "Use 'tabula' to use the version in your path, or specify an absolute path.",
      )
      .addText((text) =>
        text
          // skip as this is a name fo the executabele
          // eslint-disable-next-line obsidianmd/ui/sentence-case
          .setPlaceholder('tabula')
          .setValue(this.plugin.settings.executablePath)
          .onChange((value) => {
            this.plugin.settings.executablePath = value
            this.plugin.saveSettings()
          }),
      )

    new Setting(containerEl)
      .setName('Auto format output')
      .setDesc('Align CSV output to make it resemble a table.')
      .addToggle((toggle) =>
        toggle.setValue(this.plugin.settings.autoFormat).onChange((value) => {
          this.plugin.settings.autoFormat = value
          this.plugin.saveSettings()
        }),
      )

    new Setting(containerEl)
      .setName('Table index')
      .setDesc('Show columns and rows names')
      .addToggle((toggle) =>
        toggle.setValue(this.plugin.settings.tableIndex).onChange((value) => {
          this.plugin.settings.tableIndex = value
          this.plugin.saveSettings()
        }),
      )
  }
}
