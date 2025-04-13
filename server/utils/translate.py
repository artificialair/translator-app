from googletrans import Translator

async def translate(phrase: str, src: str, dest: str = "en"):
    translator = Translator()

    if src:
        translation = translator.translate(phrase, src=src, dest=dest)
    else:
        translation = translator.translate(phrase, dest=dest)

    return (await translation).text
