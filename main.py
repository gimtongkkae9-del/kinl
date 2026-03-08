from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.button import Button
from kivy.uix.textinput import TextInput
import os

class LuaExecutor(BoxLayout):
    def __init__(self, **kwargs):
        super(LuaExecutor, self).__init__(**kwargs)
        self.orientation = 'vertical'
        self.script_input = TextInput(hint_text='Enter Lua script', size_hint_y=None, height=200)
        self.add_widget(self.script_input)
        self.execute_button = Button(text='EXECUTE')
        self.execute_button.bind(on_press=self.execute_script)
        self.add_widget(self.execute_button)
        self.clear_button = Button(text='CLEAR')
        self.clear_button.bind(on_press=self.clear_script)
        self.add_widget(self.clear_button)
        self.execute_clipboard_button = Button(text='EXECUTE CLIPBOARD')
        self.execute_clipboard_button.bind(on_press=self.execute_clipboard)
        self.add_widget(self.execute_clipboard_button)

    def execute_script(self, instance):
        script = self.script_input.text
        with open('/sdcard/Documents/script.lua', 'w') as script_file:
            script_file.write(script)
        os.system('lua /sdcard/Documents/script.lua')

    def clear_script(self, instance):
        self.script_input.text = ''

    def execute_clipboard(self, instance):
        import pyperclip
        script = pyperclip.paste()
        self.script_input.text = script
        self.execute_script(instance)

class LuaApp(App):
    def build(self):
        return LuaExecutor()

if __name__ == '__main__':
    LuaApp().run()