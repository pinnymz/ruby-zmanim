# encoding: UTF-8
module Zmanim::Limudim
  class LimudimFormatter
    include Zmanim::Util::TextHelper
    include Zmanim::Util::HebrewNumericFormatter

    attr_accessor :hebrew_format
    PARSHIYOS = {
        bereishis:       'בראשית',
        noach:           'נח',
        lech_lecha:      'לך לך',
        vayeira:         'וירא',
        chayei_sarah:    'חיי שרה',
        toldos:          'תולדות',
        vayeitzei:       'ויצא',
        vayishlach:      'וישלח',
        vayeishev:       'וישב',
        mikeitz:         'מקץ',
        vayigash:        'ויגש',
        vayechi:         'ויחי',
        shemos:          'שמות',
        vaeirah:         'וארא',
        bo:              'בא',
        beshalach:       'בשלח',
        yisro:           'יתרו',
        mishpatim:       'משפטים',
        terumah:         'תרומה',
        tetzaveh:        'תצוה',
        ki_sisa:         'כי תשא',
        vayakheil:       'ויקהל',
        pekudei:         'פקודי',
        vayikra:         'ויקרא',
        tzav:            'צו',
        shemini:         'שמיני',
        tazria:          'תזריע',
        metzora:         'מצורע',
        acharei:         'אחרי מות',
        kedoshim:        'קדושים',
        emor:            'אמר',
        behar:           'בהר',
        bechukosai:      'בחוקתי',
        bamidbar:        'במדבר',
        naso:            'נשא',
        behaalosecha:    'בהעלותך',
        shelach:         'שלח',
        korach:          'קרח',
        chukas:          'חקת',
        balak:           'בלק',
        pinchas:         'פינחס',
        matos:           'מטות',
        masei:           'מסעי',
        devarim:         'דברים',
        vaeschanan:      'ואתחנן',
        eikev:           'עקב',
        reei:            'ראה',
        shoftim:         'שופטים',
        ki_seitzei:      'כי תצא',
        ki_savo:         'כי תבא',
        nitzavim:        'נצבים',
        vayeilech:       'וילך',
        haazinu:         'האזינו',
        vezos_haberacha: 'וזאת הברכה',
    }

    MASECHTOS = {
        berachos: 'ברכות',
        peah: 'פאה',
        demai: 'דמאי',
        kilayim: 'כלאים',
        sheviis: 'שביעית',
        terumos: 'תרומות',
        maasros: 'מעשרות',
        maaser_sheni: 'מעזר שני',
        chalah: 'חלה',
        orlah: 'ערלה',
        bikurim: 'בכורים',
        shabbos: 'שבת',
        eruvin: 'ערובין',
        pesachim: 'פסחים',
        shekalim: 'שקלים',
        yoma: 'יומא',
        sukkah: 'סוכה',
        beitzah: 'ביצה',
        rosh_hashanah: 'ראש השנה',
        taanis: 'תענית',
        megillah: 'מגילה',
        moed_katan: 'מועד קטן',
        chagigah: 'חגיגה',
        yevamos: 'יבמות',
        kesubos: 'כתובות',
        nedarim: 'נדרים',
        nazir: 'נזיר',
        sotah: 'סוטה',
        gitin: 'גיטין',
        kiddushin: 'קידושין',
        bava_kamma: 'בבא קמא',
        bava_metzia: 'בבא מציעא',
        bava_basra: 'בבא בתרא',
        sanhedrin: 'סנהדרין',
        makkos: 'מכות',
        shevuos: 'שבועות',
        eduyos: 'עדיות',
        avodah_zarah: 'עבודה זרה',
        avos: 'אבות',
        horiyos: 'הוריות',
        zevachim: 'זבחים',
        menachos: 'מנחות',
        chullin: 'חולין',
        bechoros: 'בכורות',
        arachin: 'ערכין',
        temurah: 'תמורה',
        kerisos: 'כריתות',
        meilah: 'מעילה',
        tamid: 'תמיד',
        midos: 'מידות',
        kinnim: 'קינים',
        keilim: 'כלים',
        ohalos: 'אוהלות',
        negaim: 'נגעים',
        parah: 'פרה',
        taharos: 'טהרות',
        mikvaos: 'מקואות',
        niddah: 'נדה',
        machshirim: 'מכשירין',
        zavim: 'זבים',
        tevul_yom: 'טבול יום',
        yadayim: 'ידים',
        uktzin: 'עוקצין',
        no_daf_today: 'אין דף היום',
    }

    def initialize
      super
      @use_geresh_gershayim = false
    end

    def format_parsha(limud)
      prefix = hebrew_format ? 'פרשת ' : 'Parshas '
      prefix + limud.unit.render do |parsha|
        hebrew_format ? PARSHIYOS[parsha] : titleize(parsha)
      end
    end

    def format_talmudic(limud)
      return '' unless unit = (limud && limud.unit)
      unit.render do |e|
        if e.is_a?(Numeric)
          format_number(e)
        elsif hebrew_format
          MASECHTOS[e]
        else
          titleize(e)
        end
      end
    end

    def format_tehillim(limud)
      prefix = hebrew_format ? 'תהלים ' : 'Tehillim '
      prefix + limud.unit.render {|e| format_number(e) }
    end

    private

    def format_number(number)
      hebrew_format ? format_hebrew_number(number) : number
    end
  end
end
